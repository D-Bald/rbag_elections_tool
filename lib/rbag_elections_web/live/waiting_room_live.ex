defmodule RbagElectionsWeb.WarteRaumLive do
  use RbagElectionsWeb, :live_view
  alias RbagElections.Freigabe

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl text-center">
      <.header>
        Wartezimmer
      </.header>
      <p class="text-lg mt-4">Geht gleich weiter.</p>
    </div>
    """
  end

  def mount(%{"wahl_slug" => wahl_slug}, _session, socket) do
    if connected?(socket) do
      Freigabe.subscribe(wahl_slug)
    end

    socket =
      socket
      |> assign(:wahl_slug, wahl_slug)

    wahl = RbagElections.Wahlen.get_wahl_by_slug!(wahl_slug)

    if socket.assigns.current_token && Freigabe.erteilt?(socket.assigns.current_token, wahl) do
      {:ok, redirect(socket, to: "/#{wahl_slug}")}
    else
      {:ok, socket}
    end
  end

  @doc """
  Listening to the `token:confirmed` PubSub event.
  """
  def handle_info(%Freigabe.Events.FreigabeErteilt{token: token}, socket) do
    if token.id == socket.assigns.current_token.id do
      {:noreply, redirect(socket, to: "/#{socket.assigns.wahl_slug}")}
    else
      {:noreply, socket}
    end
  end
end
