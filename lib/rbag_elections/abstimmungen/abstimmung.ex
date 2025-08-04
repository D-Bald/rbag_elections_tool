defmodule RbagElections.Abstimmungen.Abstimmung do
  use Ecto.Schema
  import Ecto.Changeset

  @type id :: integer()
  @type t :: %__MODULE__{
          id: id() | nil,
          wahl_id: RbagElections.Wahlen.Wahl.id() | nil,
          wahl: RbagElections.Wahlen.Wahl.t() | Ecto.Association.NotLoaded.t() | nil,
          position_id: RbagElections.Wahlen.Position.id() | nil,
          position: RbagElections.Wahlen.Position.t() | Ecto.Association.NotLoaded.t() | nil,
          abgaben: [RbagElections.Abstimmungen.Abgabe.t()] | Ecto.Association.NotLoaded.t() | nil,
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

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
    # Der check auf einen bestehenden unique constraint sorgt dafür, dass auf Datenbankebene versichert wird,
    # dass es nur eine (aktuelle) Abstimmung pro Wahl gibt.
    |> unique_constraint(:wahl_id)
    |> foreign_key_constraint(:wahl_id)
    |> foreign_key_constraint(:position_id)
  end
end
