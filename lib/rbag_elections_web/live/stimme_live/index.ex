defmodule RbagElectionsWeb.StimmeLive.Index do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Abstimmungen
  alias RbagElections.Abstimmungen.Stimme

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :stimmen, Abstimmungen.list_stimmen())}
  end

  @impl true
  def handle_params(
        %{"wahl_slug" => wahl_slug, "abstimmung_id" => abstimmung_id} = params,
        _url,
        socket
      ) do
    socket =
      socket
      |> assign(:wahl_slug, wahl_slug)
      |> assign(:abstimmung_id, abstimmung_id)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Stimme")
    |> assign(:stimme, Abstimmungen.get_stimme!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Stimme")
    |> assign(:stimme, %Stimme{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Stimmen")
    |> assign(:stimme, nil)
  end

  @impl true
  def handle_info({RbagElectionsWeb.StimmeLive.FormComponent, {:saved, stimme}}, socket) do
    {:noreply, stream_insert(socket, :stimmen, stimme)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    stimme = Abstimmungen.get_stimme!(id)
    {:ok, _} = Abstimmungen.delete_stimme(stimme)

    {:noreply, stream_delete(socket, :stimmen, stimme)}
  end
end
