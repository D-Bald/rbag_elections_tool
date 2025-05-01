defmodule RbagElectionsWeb.StimmeLive.Submit do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Abstimmungen
  alias RbagElections.Abstimmungen.Stimme
  alias RbagElections.Wahlen

  @impl true
  def render(assigns) do
    ~H"""
    <div>
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
    </div>
    """
  end

  # TODO: Hier auch Login als LiveComponent einbinden und über action entscheiden, was gerendert wird
  # TODO: Hier auch Warteraum durch conditional rendering ersetzen
  # TODO: Auslagern des Wahlformulars in eigene LiveComponent

  @impl true
  def mount(%{"wahl_slug" => wahl_slug}, _session, socket) do
    # TODO: Fall handlen, wenn es keine aktuelle abstimmung gibt => Warteraum rendern?
    position = Wahlen.get_position_with_options(wahl_slug)

    {:ok,
     socket
     |> assign(:wahl_slug, wahl_slug)
     |> assign(:position, position)
     |> assign(:form, to_form(Abstimmungen.change_stimme(%Stimme{})))}
  end

  @impl true
  def handle_event("save", %{"stimme" => %{"option_id" => option_id}}, socket) do
    token = socket.assigns.current_token
    wahl_slug = socket.assigns.wahl_slug

    option =
      Enum.find(socket.assigns.position.optionen, fn option ->
        option.id == String.to_integer(option_id)
      end)

    Abstimmungen.submit(wahl_slug, option, token)

    {:noreply,
     socket
     |> put_flash(:info, "Deine Stimme wird gezählt")}
  end
end
