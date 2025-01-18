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
        Abstimmen für Position {@position.nane}
      </.header>

      <.simple_form for={@form} id="stimme-form" phx-submit="save">
        <.input
          field={@form[:position_id]}
          type="select"
          label="Position"
          options={@position.optionen}
          required
        />

        <:actions>
          <.button phx-disable-with="Einreichen...">Abstimmen</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(%{"abstimmung_id" => abstimmung_id}, _session, socket) do
    position = Wahlen.get_position_with_options(abstimmung_id)

    {:ok,
     socket
     |> assign(:abstimmung_id, String.to_integer(abstimmung_id))
     |> assign(:position, position)
     |> assign(:stimme, %Stimme{})}
  end

  @impl true
  def handle_event("save", %{"stimme" => %{"option" => option}}, socket) do
    token = socket.assigns.current_token
    abstimmung_id = socket.assigns.abstimmung_id
    Abstimmungen.submit!(abstimmung_id, option, token)

    {:noreply,
     socket
     |> put_flash(:info, "Deine Stimme wird gezählt")}
  end
end
