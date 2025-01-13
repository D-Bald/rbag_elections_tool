defmodule RbagElectionsWeb.DurchgangLive.Show do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Wahlleitung

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:durchgang, Wahlleitung.get_durchgang!(id))}
  end

  defp page_title(:show), do: "Show Durchgang"
  defp page_title(:edit), do: "Edit Durchgang"
end
