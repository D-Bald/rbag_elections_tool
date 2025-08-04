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

    {:ok, wahl} = RbagElections.Wahlen.get_wahl_by_slug(wahl_slug)

    socket.assigns.current_token &&
      case Freigabe.erteilt(socket.assigns.current_token, wahl) do
        {:ok, true} ->
          {:ok,
           socket
           |> redirect(to: "/#{wahl_slug}")}

        _ ->
          {:ok, socket}
      end
  end

  @doc """
  Listening to the Freigabe PubSub event.
  """
  @impl true
  def handle_info(%Freigabe.Events.FreigabeErteilt{wahl_freigabe: wahl_freigabe}, socket) do
    if wahl_freigabe.token_id == socket.assigns.current_token.id do
      {:noreply, redirect(socket, to: "/#{socket.assigns.wahl_slug}")}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(%Freigabe.Events.FreigabeAbgelehnt{wahl_freigabe: wahl_freigabe}, socket) do
    if wahl_freigabe.token_id == socket.assigns.current_token.id do
      {:noreply, put_flash(socket, :error, "Deine Freigabe wurde abgelehnt.")}
    else
      {:noreply, socket}
    end
  end

  # Ignore other messages
  @impl true
  def handle_info(_msg, socket) do
    {:noreply, socket}
  end
end
