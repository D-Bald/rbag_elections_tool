defmodule RbagElections.Wahlen.Position do
  use Ecto.Schema
  import Ecto.Changeset

  schema "positionen" do
    field :name, :string

    belongs_to :wahl, RbagElections.Wahlen.Wahl
    has_many :optionen, RbagElections.Wahlen.Option

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
