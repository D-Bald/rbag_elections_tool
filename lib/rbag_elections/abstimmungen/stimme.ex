defmodule RbagElections.Abstimmungen.Stimme do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stimmen" do
    belongs_to :abstimmung, RbagElections.Abstimmungen.Abstimmung
    belongs_to :position, RbagElections.Wahlen.Position

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(stimme, attrs) do
    stimme
    |> cast(attrs, [:abstimmung_id, :position_id])
    |> validate_required([:abstimmung_id, :position_id])
    |> foreign_key_constraint(:abstimmung_id)
    |> foreign_key_constraint(:position_id)
  end
end
