defmodule RbagElectionsWeb.AbgabeLive.Index do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Abstimmungen
  alias RbagElections.Abstimmungen.Abgabe

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :abgaben, Abstimmungen.list_abgaben())}
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
    |> assign(:page_title, "Edit abgabe")
    |> assign(:abgabe, Abstimmungen.get_abgabe!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New abgabe")
    |> assign(:abgabe, %Abgabe{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing abgaben")
    |> assign(:abgabe, nil)
  end

  @impl true
  def handle_info({RbagElectionsWeb.AbgabeLive.FormComponent, {:saved, abgabe}}, socket) do
    {:noreply, stream_insert(socket, :abgaben, abgabe)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    abgabe = Abstimmungen.get_abgabe!(id)
    {:ok, _} = Abstimmungen.delete_abgabe(abgabe)

    {:noreply, stream_delete(socket, :abgaben, abgabe)}
  end
end
