defmodule RbagElections.Wahlen.Option do
  use Ecto.Schema
  import Ecto.Changeset

  schema "optionen" do
    field :wert, :string

    belongs_to :position, RbagElections.Wahlen.Position

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(option, attrs) do
    option
    |> cast(attrs, [:wert, :position_id])
    |> validate_required([:wert, :position_id])
    |> foreign_key_constraint(:position_id)
  end
end
