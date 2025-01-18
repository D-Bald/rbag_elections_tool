defmodule RbagElectionsWeb.TokenLive.Index do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Freigabe

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl">
      <.header class="text-center">
        Benutzer bestätigen
      </.header>

      <h2 class="text-lg">Pending Tokens</h2>
      <.table id="pending_tokens" rows={@pending_tokens}>
        <:col :let={token} label="Name">{token.besitzer}</:col>
        <:action :let={token}>
          <button phx-click="confirm" phx-value-id={token.id}>Bestätigen</button>
        </:action>
      </.table>

      <h2 class="text-lg">Registered Users</h2>
      <.table id="confirmed_tokens" rows={@confirmed_tokens}>
        <:col :let={token} label="Name">{token.besitzer}</:col>
        <:action :let={token}>
          <button phx-click="delete" phx-value-id={token.id}>Löschen</button>
        </:action>
      </.table>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    pending_tokens = Freigabe.list_pending_tokens()
    confirmed_tokens = Freigabe.list_confirmed_tokens()

    {:ok, assign(socket, pending_tokens: pending_tokens, confirmed_tokens: confirmed_tokens)}
  end

  def handle_event("confirm", %{"id" => id}, socket) do
    token =
      socket.assigns.pending_tokens
      |> Enum.find(fn token -> token.id == String.to_integer(id) end)

    case Freigabe.confirm_token(token) do
      {:ok, token} ->
        {:noreply,
         socket
         |> update(:pending_tokens, fn tokens -> Enum.reject(tokens, &(&1.id == id)) end)
         |> update(:confirmed_tokens, fn tokens -> [token | tokens] end)}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    token =
      socket.assigns.confirmed_tokens
      |> Enum.find(fn token -> token.id == String.to_integer(id) end)

    case Freigabe.delete_token(token) do
      {:ok, _} ->
        {:noreply,
         socket
         |> update(:confirmed_tokens, fn tokens -> Enum.reject(tokens, &(&1.id == token.id)) end)}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end
end
