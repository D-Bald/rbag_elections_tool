defmodule RbagElectionsWeb.StimmeLive.Aggregate do
  use RbagElectionsWeb, :live_view

  alias RbagElections.Abstimmungen

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Stimmen für die Position {@position.name}
      </.header>

      <.table id="stimmen" rows={@stimmen}>
        <:col :let={stimme} label="Position">{stimme.option.wert}</:col>
        <:col :let={stimme} label="Votes">{stimme.count}</:col>
      </.table>
    </div>
    """
  end

  @impl true
  def mount(%{"abstimmung_id" => abstimmung_id}, _session, socket) do
    abstimmung_id = String.to_integer(abstimmung_id)
    position = Abstimmungen.get_position_with_options(abstimmung_id)
    stimmen = Abstimmungen.aggregate_stimmen_by_option(abstimmung_id)

    {:ok,
     socket
     |> assign(:position, position)
     |> assign(:stimmen, stimmen)}
  end
end
