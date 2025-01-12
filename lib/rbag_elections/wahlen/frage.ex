defmodule RbagElections.Wahlen.Frage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fragen" do
    field :index, :integer
    field :beschreibung, :string

    belongs_to :wahl, RbagElections.Wahlen.Wahl

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(frage, attrs) do
    frage
    |> cast(attrs, [:beschreibung, :index])
    |> validate_required([:beschreibung, :index, :wahl_id])
    |> foreign_key_constraint(:wahl_id)
  end
end
