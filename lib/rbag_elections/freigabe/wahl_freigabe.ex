defmodule RbagElections.Freigabe.WahlFreigabe do
  use Ecto.Schema
  import Ecto.Changeset

  alias RbagElections.Freigabe.Token
  alias RbagElections.Wahlen.Wahl

  schema "wahl_freigaben" do
    field :freigegeben, :boolean, default: false

    belongs_to :token, Token
    belongs_to :wahl, Wahl

    timestamps()
  end

  @doc false
  def changeset(wahl_freigabe, attrs \\ %{}) do
    wahl_freigabe
    |> cast(attrs, [:freigegeben, :token_id, :wahl_id])
    |> validate_required([:freigegeben, :token_id, :wahl_id])
    |> foreign_key_constraint(:token_id)
    |> foreign_key_constraint(:wahl_id)
    |> unique_constraint([:token_id, :wahl_id])
  end
end
