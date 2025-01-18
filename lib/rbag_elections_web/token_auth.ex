defmodule RbagElectionsWeb.TokenAuth do
  use RbagElectionsWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias RbagElections.Freigabe

  # Make the remember me cookie valid for 60 days.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_rbag_elections_web_token_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc """
  Logs the token in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  def log_in_token(conn, besitzer, params \\ %{}) do
    token = Freigabe.generate_session_token(besitzer)

    conn
    |> renew_session()
    |> put_token_in_session(token)
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: signed_in_path(conn))
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    delete_csrf_token()

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the token out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_token(conn) do
    value = get_session(conn, :token_value)
    value && Freigabe.delete_token_by_value(value)

    if live_socket_id = get_session(conn, :live_socket_id) do
      RbagElectionsWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: ~p"/")
  end

  @doc """
  Authenticates the token by looking into the session
  and remember me token.
  """
  def fetch_current_token(conn, _opts) do
    {value, conn} = ensure_token_value(conn)
    token = value && Freigabe.get_token_by_session_token_value(value)
    assign(conn, :current_token, token)
  end

  defp ensure_token_value(conn) do
    if value = get_session(conn, :token_value) do
      {value, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if token = conn.cookies[@remember_me_cookie] do
        {token, put_token_in_session(conn, token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Handles mounting and authenticating the current_token in LiveViews.

  ## `on_mount` arguments

    * `:mount_current_token` - Assigns current_token
      to socket assigns based on current_token, or nil if
      there's no current_token or no matching token.

    * `:ensure_authenticated` - Authenticates the token from the session,
      and assigns the current_token to socket assigns based
      on current_token.
      Redirects to login page if there's no logged token.

    * `:redirect_if_token_is_authenticated` - Authenticates the token from the session.
      Redirects to signed_in_path if there's a logged token.

  ## Examples

  Use the `on_mount` lifecycle macro in LiveViews to mount or authenticate
  the current_token:

      defmodule RbagElectionsWeb.PageLive do
        use RbagElectionsWeb, :live_view

        on_mount {RbagElectionsWeb.TokenAuth, :mount_current_token}
        ...
      end

  Or use the `live_session` of your router to invoke the on_mount callback:

      live_session :authenticated, on_mount: [{RbagElectionsWeb.TokenAuth, :ensure_authenticated}] do
        live "/profile", ProfileLive, :index
      end
  """
  def on_mount(:mount_current_token, _params, session, socket) do
    {:cont, mount_current_token(socket, session)}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_current_token(socket, session)

    if socket.assigns.current_token do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/login")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_token_is_authenticated, _params, session, socket) do
    socket = mount_current_token(socket, session)

    if socket.assigns.current_token do
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_in_path(socket))}
    else
      {:cont, socket}
    end
  end

  defp mount_current_token(socket, session) do
    Phoenix.Component.assign_new(socket, :current_token, fn ->
      if token_value = session["token_value"] do
        Freigabe.get_token_by_session_token_value(token_value)
      end
    end)
  end

  @doc """
  Used for routes that require the token to not be authenticated.
  """
  def redirect_if_token_is_authenticated(conn, _opts) do
    if conn.assigns[:current_token] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the token to be confirmed.

  If you want to enforce the token is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_confirmed_token(conn, _opts) do
    token = conn.assigns[:current_token]

    if token && token.freigegeben do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end

  @doc """
  Used for routes that require the token to be authenticated.

  If you want to enforce the token is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_token(conn, _opts) do
    token = conn.assigns[:current_token]

    if token do
      IO.inspect(token, label: "happy path")
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end

  defp put_token_in_session(conn, value) do
    conn
    |> put_session(:token_value, value)
    |> put_session(:live_socket_id, "tokens_sessions:#{Base.url_encode64(value)}")
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :token_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: ~p"/warteraum"
end
