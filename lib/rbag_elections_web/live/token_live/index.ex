defmodule RbagElectionsWeb.TokenLive.Index do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Freigabe
  alias RbagElections.Wahlen
  alias RbagElections.Abstimmungen
  alias RbagElections.Abstimmungen.Abstimmung
  alias RbagElectionsWeb.TokenLive.UserState

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl">
      <.header class="text-center">
        Benutzer bestätigen
      </.header>

      <h2 class="text-lg">Offene Freigaben</h2>
      <.table id="offene_freigaben" rows={@offene_freigaben}>
        <:col :let={user_state} label="Name">{user_state.freigabe.token.besitzer}</:col>
        <:action :let={user_state}>
          <button phx-click="confirm" phx-value-id={user_state.freigabe.id}>Bestätigen</button>
        </:action>
      </.table>

      <h2 class="text-lg">Bestätigte Freigaben</h2>
      <.table
        id="erteilte_freigaben"
        rows={@erteilte_freigaben}
        row_class={
          fn %{abgegeben: abgegeben} ->
            if abgegeben,
              do: "bg-green-100 border border-green-400",
              else: ""
          end
        }
      >
        <:col :let={user_state} label="Name">{user_state.freigabe.token.besitzer}</:col>
        <:action :let={user_state}>
          <button phx-click="reject" phx-value-id={user_state.freigabe.id}>Widerrufen</button>
        </:action>
      </.table>

      <h2 class="text-lg">Abgelehnte Freigaben</h2>
      <.table id="abgelehnte_freigaben" rows={@abgelehnte_freigaben}>
        <:col :let={user_state} label="Name">{user_state.freigabe.token.besitzer}</:col>
        <:action :let={user_state}>
          <button phx-click="rehabilitate" phx-value-id={user_state.freigabe.id}>Bestätigen</button>
          <span>|</span>
          <button phx-click="delete" phx-value-id={user_state.freigabe.id}>Entgültig löschen</button>
        </:action>
      </.table>
    </div>
    """
  end

  @impl true
  def mount(%{"wahl_slug" => wahl_slug}, _session, socket) do
    if connected?(socket) do
      Freigabe.subscribe(wahl_slug)

      with {:ok, abstimmung} <- Wahlen.get_aktuelle_abstimmung(wahl_slug) do
        Abstimmungen.subscribe_to_abgaben(abstimmung)
      end

      # TODO: Somehow i don't get events from here:
      # - are they broadcasted?!
      # - is the subscription wrong
      # - is just the handle event not receiving the correct event?

      # TODO: fetch list of abgaben for the current Abstimmung to initialize the state correctly
      # TODO: subscribe to new Abstimmung starting to reset the "abgegeben" state for each Freigabe
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"wahl_slug" => wahl_slug}, _url, socket) do
    offene_freigaben =
      Freigabe.list_offene_freigaben(wahl_slug)
      |> Enum.map(&%UserState{freigabe: &1})

    erteilte_freigaben =
      Freigabe.list_erteilte_freigaben(wahl_slug)
      |> Enum.map(&%UserState{freigabe: &1})

    abgelehnte_freigaben =
      Freigabe.list_abgelehnte_freigaben(wahl_slug)
      |> Enum.map(&%UserState{freigabe: &1})

    {:ok, wahl} = Wahlen.get_wahl_by_slug(wahl_slug)

    {:noreply,
     assign(socket,
       wahl: wahl,
       offene_freigaben: offene_freigaben,
       erteilte_freigaben: erteilte_freigaben,
       abgelehnte_freigaben: abgelehnte_freigaben
     )}
  end

  @doc """
  Listening to the Freigabe PubSub event.
  """
  @impl true
  def handle_info(%Freigabe.Events.FreigabeAngefragt{wahl_freigabe: wahl_freigabe}, socket) do
    {:noreply,
     socket
     |> update(:offene_freigaben, fn freigaben ->
       [%UserState{freigabe: wahl_freigabe} | freigaben]
     end)}
  end

  def handle_info(%Abstimmungen.Events.AbgabeEingereicht{token_id: token_id}, socket) do
    {:noreply,
     socket
     |> update(:erteilte_freigaben, fn list_of_user_states ->
       Enum.map(list_of_user_states, fn user_state ->
         if user_state.freigabe.token.id == token_id do
           %{user_state | abgegeben: true}
         else
           user_state
         end
       end)
     end)}
  end

  # Ignore other messages
  @impl true
  def handle_info(_msg, socket) do
    {:noreply, socket}
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
         |> update(:abgelehnte_freigaben, fn list_of_user_states ->
           Enum.map(list_of_user_states, & &1.freigabe)
           |> Enum.reject(&(&1.id == id))
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
         |> update(from_list, fn list_of_user_states ->
           Enum.map(list_of_user_states, & &1.freigabe)
           |> Enum.reject(&(&1.id == id))
         end)
         |> update(to_list, fn list_of_user_states ->
           [%UserState{freigabe: updated_freigabe} | list_of_user_states]
         end)}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  defp find_freigabe_by_id(list_of_user_state, id) do
    Enum.map(list_of_user_state, & &1.freigabe)
    |> Enum.find(&(&1.id == id))
  end
end
