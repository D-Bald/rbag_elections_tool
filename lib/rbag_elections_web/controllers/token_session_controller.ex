defmodule RbagElectionsWeb.TokenSessionController do
  use RbagElectionsWeb, :controller

  alias RbagElectionsWeb.TokenAuth

  def create(conn, %{"token" => token_params}) do
    conn
    |> put_flash(:info, "Jetzt kann es losgehen")
    |> TokenAuth.log_in_token(token_params["besitzer"], %{
      "remember_me" => "true"
    })
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> TokenAuth.log_out_token()
  end
end
