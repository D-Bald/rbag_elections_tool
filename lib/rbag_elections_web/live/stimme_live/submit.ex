defmodule RbagElectionsWeb.StimmeLive.Submit do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Wahlen
  alias RbagElections.Abstimmungen
  alias RbagElections.Abstimmungen.Stimme

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= if @has_active_voting do %>
        <.header>
          Abstimmen für Position {@position.name}
        </.header>

        <.simple_form for={@form} id="stimme-form" phx-submit="save">
          <.input
            field={@form[:option_id]}
            type="select"
            label="Option"
            options={Enum.map(@position.optionen, &{&1.wert, &1.id})}
            required
          />

          <:actions>
            <.button phx-disable-with="Einreichen...">Abstimmen</.button>
          </:actions>
        </.simple_form>
      <% else %>
        <.header>
          Wartezimmer
        </.header>
        <p class="text-lg mt-4">Es gibt aktuell keine laufende Abstimmung. Bitte warten.</p>
      <% end %>
    </div>
    """
  end

  # TODO: Hier auch Login als LiveComponent einbinden und über action entscheiden, was gerendert wird
  # TODO: Auslagern des Wahlformulars in eigene LiveComponent

  @impl true
  def mount(%{"wahl_slug" => wahl_slug}, _session, socket) do
    if connected?(socket) do
      Abstimmungen.subscribe(wahl_slug)
    end

    case Wahlen.get_aktuelle_abstimmung_with_position_and_options(wahl_slug) do
      nil ->
        {:ok,
         socket
         |> assign(:wahl_slug, wahl_slug)
         |> assign(:has_active_voting, false)
         |> assign(:position, nil)
         |> assign(:form, nil)}

      abstimmung ->
        {:ok,
         socket
         |> assign(:wahl_slug, wahl_slug)
         |> assign(:has_active_voting, true)
         |> assign(:position, abstimmung.position)
         |> assign(:form, to_form(Abstimmungen.change_stimme(%Stimme{})))}
    end
  end

  @impl true
  def handle_event("save", %{"stimme" => %{"option_id" => option_id}}, socket) do
    token = socket.assigns.current_token
    wahl_slug = socket.assigns.wahl_slug

    option =
      Enum.find(socket.assigns.position.optionen, fn option ->
        option.id == String.to_integer(option_id)
      end)

    Abstimmungen.abgeben(wahl_slug, option, token)

    {:noreply,
     socket
     |> put_flash(:info, "Deine Stimme wird gezählt")}
  end

  @impl true
  def handle_info({:abstimmung_started, abstimmung}, socket) do
    {:noreply,
     socket
     |> assign(:has_active_voting, true)
     |> assign(:position, abstimmung.position)
     |> assign(:form, to_form(Abstimmungen.change_stimme(%Stimme{})))}
  end

  @impl true
  def handle_info({:abstimmung_ended, _}, socket) do
    {:noreply,
     socket
     |> assign(:has_active_voting, false)
     |> assign(:position, nil)
     |> assign(:form, nil)}
  end
end
