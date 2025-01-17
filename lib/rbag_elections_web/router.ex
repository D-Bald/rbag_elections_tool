defmodule RbagElectionsWeb.Router do
  use RbagElectionsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RbagElectionsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RbagElectionsWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/tokens", TokenLive.Index, :index
    live "/tokens/new", TokenLive.Index, :new
    live "/tokens/:id/edit", TokenLive.Index, :edit
    live "/tokens/:id", TokenLive.Show, :show
    live "/tokens/:id/show/edit", TokenLive.Show, :edit

    resources "/wahlen", WahlController, param: "slug" do
      resources "/positionen", PositionController do
        resources "/optionen", OptionController
      end
    end

    live "/:wahl_slug/abstimmungen", AbstimmungLive.Index, :index
    live "/:wahl_slug/abstimmungen/new", AbstimmungLive.Index, :new
    live "/:wahl_slug/abstimmungen/:id/edit", AbstimmungLive.Index, :edit

    live "/:wahl_slug/abstimmungen/:id", AbstimmungLive.Show, :show
    live "/:wahl_slug/abstimmungen/:id/show/edit", AbstimmungLive.Show, :edit

    live "/:wahl_slug/abstimmungen/:abstimmung_id/abgaben", AbgabeLive.Index, :index
    live "/:wahl_slug/abstimmungen/:abstimmung_id/abgaben/new", AbgabeLive.Index, :new

    live "/:wahl_slug/abstimmungen/:abstimmung_id/abgaben/:id/edit",
         AbgabeLive.Index,
         :edit

    live "/:wahl_slug/abstimmungen/:abstimmung_id/abgaben/:id", AbgabeLive.Show, :show

    live "/:wahl_slug/abstimmungen/:abstimmung_id/abgaben/:id/show/edit",
         AbgabeLive.Show,
         :edit

    live "/:wahl_slug/abstimmungen/:abstimmung_id/stimmen", StimmeLive.Index, :index
    live "/:wahl_slug/abstimmungen/:abstimmung_id/stimmen/new", StimmeLive.Index, :new
    live "/:wahl_slug/abstimmungen/:abstimmung_id/stimmen/:id/edit", StimmeLive.Index, :edit

    live "/:wahl_slug/abstimmungen/:abstimmung_id/stimmen/:id", StimmeLive.Show, :show
    live "/:wahl_slug/abstimmungen/:abstimmung_id/stimmen/:id/show/edit", StimmeLive.Show, :edit
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
