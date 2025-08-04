defmodule RbagElections.Wahlen.Position do
  use Ecto.Schema
  import Ecto.Changeset

  @type id :: integer()
  @type t :: %__MODULE__{
          id: id() | nil,
          name: String.t() | nil,
          wahl_id: RbagElections.Wahlen.Wahl.id() | nil,
          wahl: RbagElections.Wahlen.Wahl.t() | Ecto.Association.NotLoaded.t() | nil,
          optionen: [RbagElections.Wahlen.Option.t()] | Ecto.Association.NotLoaded.t() | nil,
          abstimmungen:
            [RbagElections.Abstimmungen.Abstimmung.t()] | Ecto.Association.NotLoaded.t() | nil,
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  schema "positionen" do
    field :name, :string

    belongs_to :wahl, RbagElections.Wahlen.Wahl
    has_many :optionen, RbagElections.Wahlen.Option
    has_many :abstimmungen, RbagElections.Abstimmungen.Abstimmung

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, [:name, :wahl_id])
    |> validate_required([:name, :wahl_id])
    |> foreign_key_constraint(:wahl_id)
  end
end
