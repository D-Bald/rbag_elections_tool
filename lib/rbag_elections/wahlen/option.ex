defmodule RbagElections.Wahlen.Option do
  use Ecto.Schema
  import Ecto.Changeset

  schema "optionen" do
    field :wert, :string
    field :frage_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(option, attrs) do
    option
    |> cast(attrs, [:wert])
    |> validate_required([:wert])
  end
end
