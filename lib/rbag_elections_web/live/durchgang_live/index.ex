defmodule RbagElectionsWeb.DurchgangLive.Index do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Wahlleitung
  alias RbagElections.Wahlleitung.Durchgang

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :durchgaenge, Wahlleitung.list_durchgaenge())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Durchgang")
    |> assign(:durchgang, Wahlleitung.get_durchgang!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Durchgang")
    |> assign(:durchgang, %Durchgang{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Durchgaenge")
    |> assign(:durchgang, nil)
  end

  @impl true
  def handle_info({RbagElectionsWeb.DurchgangLive.FormComponent, {:saved, durchgang}}, socket) do
    {:noreply, stream_insert(socket, :durchgaenge, durchgang)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    durchgang = Wahlleitung.get_durchgang!(id)
    {:ok, _} = Wahlleitung.delete_durchgang(durchgang)

    {:noreply, stream_delete(socket, :durchgaenge, durchgang)}
  end
end
