defmodule RbagElections.Wahlen.Wahl do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wahlen" do
    field :beschreibung, :string

    has_many :positionen, RbagElections.Wahlen.Position

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wahl, attrs) do
    wahl
    |> cast(attrs, [:beschreibung])
    |> validate_required([:beschreibung])
  end
end
