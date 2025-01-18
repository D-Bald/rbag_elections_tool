defmodule RbagElectionsWeb.Router do
  use RbagElectionsWeb, :router

  import RbagElectionsWeb.AdminAuth
  import RbagElectionsWeb.TokenAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RbagElectionsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_admin
    plug :fetch_current_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## Authentication routes

  scope "/", RbagElectionsWeb do
    pipe_through [:browser, :redirect_if_token_is_authenticated]

    live_session :redirect_if_token_is_authenticated,
      on_mount: [{RbagElectionsWeb.TokenAuth, :redirect_if_token_is_authenticated}] do
      live "/login", TokenRegistrationLive, :new
    end

    post "/login", TokenSessionController, :create
  end

  scope "/", RbagElectionsWeb do
    pipe_through [:browser, :redirect_if_admin_is_authenticated]

    live_session :redirect_if_admin_is_authenticated,
      on_mount: [{RbagElectionsWeb.AdminAuth, :redirect_if_admin_is_authenticated}] do
      live "/admins/register", AdminRegistrationLive, :new
      live "/admins/log_in", AdminLoginLive, :new
    end

    post "/admins/log_in", AdminSessionController, :create
  end

  scope "/", RbagElectionsWeb do
    pipe_through [:browser]

    delete "/admins/log_out", AdminSessionController, :delete
    delete "/tokens/log_out", TokenSessionController, :delete
  end

  ## Routes with confirmed token

  scope "/", RbagElectionsWeb do
    pipe_through [:browser, :require_confirmed_token]

    live_session :require_confirmed_token,
      on_mount: [{RbagElectionsWeb.TokenAuth, :ensure_authenticated}] do
      live "/stimmen/:abstimmung_id/abgeben", StimmeLive.Submit, :new
    end
  end

  scope "/", RbagElectionsWeb do
    pipe_through [:browser, :require_authenticated_token]

    live_session :require_authenticated_token,
      on_mount: [{RbagElectionsWeb.TokenAuth, :ensure_authenticated}] do
      live "/warteraum", WarteRaumLive, :index
    end
  end

  ## Admin routes

  scope "/", RbagElectionsWeb do
    pipe_through [:browser, :require_authenticated_admin]

    resources "/wahlen", WahlController, param: "slug" do
      resources "/positionen", PositionController do
        resources "/optionen", OptionController
      end
    end

    live_session :require_authenticated_admin,
      on_mount: [{RbagElectionsWeb.AdminAuth, :ensure_authenticated}] do
      live "/stimmen/:abstimmung_id", StimmeLive.Aggregate, :index

      live "/tokens", TokenLive.Index, :index
    end
  end

  # Unused routes
  scope "/", RbagElectionsWeb do
    pipe_through [:browser, :require_authenticated_admin]

    get "/", PageController, :home

    live "/:wahl_slug/abstimmungen", AbstimmungLive.Index, :index
    live "/:wahl_slug/abstimmungen/new", AbstimmungLive.Index, :new
    live "/:wahl_slug/abstimmungen/:id/edit", AbstimmungLive.Index, :edit
    live "/:wahl_slug/abstimmungen/:id", AbstimmungLive.Show, :show
    live "/:wahl_slug/abstimmungen/:id/show/edit", AbstimmungLive.Show, :edit

    live "/:wahl_slug/abstimmungen/:abstimmung_id/abgaben", AbgabeLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", RbagElectionsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:rbag_elections, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RbagElectionsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
