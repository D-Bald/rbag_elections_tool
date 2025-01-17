defmodule RbagElections.Abstimmungen.Abgabe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "abgaben" do
    belongs_to :token, RbagElections.Freigabe.Token
    belongs_to :abstimmung, RbagElections.Abstimmungen.Abstimmung

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(abgabe, attrs) do
    abgabe
    |> cast(attrs, [:token_id, :abstimmung_id])
    |> validate_required([:token_id, :abstimmung_id])
    |> foreign_key_constraint(:token_id)
    |> foreign_key_constraint(:abstimmung_id)
  end
end
