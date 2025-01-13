defmodule RbagElectionsWeb.TokenLive.Index do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Freigabe
  alias RbagElections.Freigabe.Token

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tokens, Freigabe.list_tokens())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Token")
    |> assign(:token, Freigabe.get_token!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Token")
    |> assign(:token, %Token{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tokens")
    |> assign(:token, nil)
  end

  @impl true
  def handle_info({RbagElectionsWeb.TokenLive.FormComponent, {:saved, token}}, socket) do
    {:noreply, stream_insert(socket, :tokens, token)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    token = Freigabe.get_token!(id)
    {:ok, _} = Freigabe.delete_token(token)

    {:noreply, stream_delete(socket, :tokens, token)}
  end
end
