defmodule RbagElectionsWeb.AbstimmungLive.Index do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Abstimmungen
  alias RbagElections.Abstimmungen.Abstimmung

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :abstimmungen, Abstimmungen.list_abstimmungen())}
  end

  @impl true
  def handle_params(%{"wahl_slug" => wahl_slug} = params, _url, socket) do
    socket =
      socket
      |> assign(:wahl_slug, wahl_slug)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Abstimmung")
    |> assign(:abstimmung, Abstimmungen.get_abstimmung!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Abstimmung")
    |> assign(:abstimmung, %Abstimmung{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Abstimmungen")
    |> assign(:abstimmung, nil)
  end

  @impl true
  def handle_info({RbagElectionsWeb.AbstimmungLive.FormComponent, {:saved, abstimmung}}, socket) do
    {:noreply, stream_insert(socket, :abstimmungen, abstimmung)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    abstimmung = Abstimmungen.get_abstimmung!(id)
    {:ok, _} = Abstimmungen.delete_abstimmung(abstimmung)

    {:noreply, stream_delete(socket, :abstimmungen, abstimmung)}
  end
end
