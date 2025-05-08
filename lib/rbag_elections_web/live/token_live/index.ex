defmodule RbagElectionsWeb.TokenLive.Index do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Freigabe
  alias RbagElections.Wahlen

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl">
      <.header class="text-center">
        Benutzer bestätigen
      </.header>

      <h2 class="text-lg">Offene Freigaben</h2>
      <.table id="offene_freigaben" rows={@offene_freigaben}>
        <:col :let={freigabe} label="Name">{freigabe.token.besitzer}</:col>
        <:action :let={freigabe}>
          <button phx-click="confirm" phx-value-id={freigabe.id}>Bestätigen</button>
        </:action>
      </.table>

      <h2 class="text-lg">Bestätigte Freigaben</h2>
      <.table id="erteilte_freigaben" rows={@erteilte_freigaben}>
        <:col :let={freigabe} label="Name">{freigabe.token.besitzer}</:col>
        <:action :let={freigabe}>
          <button phx-click="reject" phx-value-id={freigabe.id}>Widerrufen</button>
        </:action>
      </.table>

      <h2 class="text-lg">Abgelehnte Freigaben</h2>
      <.table id="abgelehnte_freigaben" rows={@abgelehnte_freigaben}>
        <:col :let={freigabe} label="Name">{freigabe.token.besitzer}</:col>
        <:action :let={freigabe}>
          <button phx-click="rehabilitate" phx-value-id={freigabe.id}>Bestätigen</button>
          <span>|</span>
          <button phx-click="delete" phx-value-id={freigabe.id}>Entgültig löschen</button>
        </:action>
      </.table>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    # TODO: subscribe to new freigaben anfragen

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"wahl_slug" => wahl_slug}, _url, socket) do
    offene_freigaben = Freigabe.list_offene_freigaben(wahl_slug)
    erteilte_freigaben = Freigabe.list_erteilte_freigaben(wahl_slug)
    abgelehnte_freigaben = Freigabe.list_abgelehnte_freigaben(wahl_slug)
    {:ok, wahl} = Wahlen.get_wahl_by_slug(wahl_slug)

    {:noreply,
     assign(socket,
       wahl: wahl,
       offene_freigaben: offene_freigaben,
       erteilte_freigaben: erteilte_freigaben,
       abgelehnte_freigaben: abgelehnte_freigaben
     )}
  end

  @impl true
  def handle_event("confirm", %{"id" => id}, socket) do
    move_freigabe(
      socket,
      id,
      :offene_freigaben,
      :erteilte_freigaben,
      &Freigabe.erteilen/1
    )
  end

  @impl true
  def handle_event("rehabilitate", %{"id" => id}, socket) do
    move_freigabe(
      socket,
      id,
      :abgelehnte_freigaben,
      :erteilte_freigaben,
      &Freigabe.erteilen/1
    )
  end

  @impl true
  def handle_event("reject", %{"id" => id}, socket) do
    move_freigabe(
      socket,
      id,
      :erteilte_freigaben,
      :abgelehnte_freigaben,
      &Freigabe.ablehnen/1
    )
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    id = String.to_integer(id)
    freigabe = find_freigabe_by_id(socket.assigns.abgelehnte_freigaben, id)

    case Freigabe.löschen(freigabe) do
      {:ok, _} ->
        {:noreply,
         socket
         |> update(:abgelehnte_freigaben, fn freigaben ->
           Enum.reject(freigaben, &(&1.id == id))
         end)}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  defp move_freigabe(socket, id, from_list, to_list, action_fn) when is_binary(id) do
    move_freigabe(socket, String.to_integer(id), from_list, to_list, action_fn)
  end

  defp move_freigabe(socket, id, from_list, to_list, action_fn) when is_integer(id) do
    freigabe = find_freigabe_by_id(socket.assigns[from_list], id)

    # TODO: hier mit "stream_insert" und "stream_delete" arbeiten? (siehe AbstimmungLive.Index)
    case action_fn.(freigabe) do
      {:ok, updated_freigabe} ->
        {:noreply,
         socket
         |> update(from_list, fn freigaben -> Enum.reject(freigaben, &(&1.id == id)) end)
         |> update(to_list, fn freigaben -> [updated_freigabe | freigaben] end)}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  defp find_freigabe_by_id(freigaben, id) do
    Enum.find(freigaben, fn freigabe -> freigabe.id == id end)
  end
end
