defmodule RbagElections.Abstimmungen.Abstimmung do
  use Ecto.Schema
  import Ecto.Changeset

  schema "abstimmungen" do
    belongs_to :wahl, RbagElections.Wahlen.Wahl
    belongs_to :position, RbagElections.Wahlen.Position
    has_many :abgaben, RbagElections.Abstimmungen.Abgabe

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(abstimmung, attrs) do
    abstimmung
    |> cast(attrs, [:wahl_id, :position_id])
    |> validate_required([:position_id])
    |> foreign_key_constraint(:wahl_id)
    |> foreign_key_constraint(:position_id)
  end
end
