defmodule RbagElections.Abstimmungen.Abgabe do
  use Ecto.Schema
  import Ecto.Changeset

  @type id :: integer()
  @type t :: %__MODULE__{
          id: id() | nil,
          token_id: RbagElections.Freigabe.Token.id() | nil,
          token: RbagElections.Freigabe.Token.t() | Ecto.Association.NotLoaded.t() | nil,
          abstimmung_id: RbagElections.Abstimmungen.Abstimmung.id() | nil,
          abstimmung:
            RbagElections.Abstimmungen.Abstimmung.t() | Ecto.Association.NotLoaded.t() | nil
        }

  schema "abgaben" do
    belongs_to :token, RbagElections.Freigabe.Token
    belongs_to :abstimmung, RbagElections.Abstimmungen.Abstimmung
  end

  @doc false
  def changeset(abgabe, attrs) do
    abgabe
    |> cast(attrs, [:token_id, :abstimmung_id])
    |> validate_required([:token_id, :abstimmung_id])
    |> foreign_key_constraint(:token_id)
    |> foreign_key_constraint(:abstimmung_id)
    |> unique_constraint([:token_id, :abstimmung_id], name: :abgaben_token_id_abstimmung_id_index)
  end
end
