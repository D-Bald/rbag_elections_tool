defmodule RbagElections.Freigabe.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :uuid, Ecto.UUID
    field :besitzer, :string
    field :freigegeben, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:uuid, :besitzer, :freigegeben])
    |> validate_required([:uuid, :besitzer, :freigegeben])
    |> unique_constraint(:uuid)
  end
end
