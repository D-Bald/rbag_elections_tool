defmodule RbagElectionsWeb.AbstimmungLive.Show do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Abstimmungen

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"wahl_slug" => wahl_slug, "id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:wahl_slug, wahl_slug)
     |> assign(:abstimmung, Abstimmungen.get_abstimmung!(id))}
  end

  defp page_title(:show), do: "Show Abstimmung"
  defp page_title(:edit), do: "Edit Abstimmung"
end
