defmodule RbagElections.Freigabe.WahlFreigabe do
  use Ecto.Schema
  import Ecto.Changeset

  alias RbagElections.Freigabe.Token
  alias RbagElections.Wahlen.Wahl

  @type t :: %__MODULE__{
          id: integer() | nil,
          status: :offen | :erteilt | :abgelehnt,
          token_id: Token.id() | nil,
          token: Token.t() | Ecto.Association.NotLoaded.t() | nil,
          wahl_id: Wahl.id() | nil,
          wahl: Wahl.t() | Ecto.Association.NotLoaded.t() | nil,
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  schema "wahl_freigaben" do
    field :status, Ecto.Enum, values: [:offen, :erteilt, :abgelehnt], default: :offen

    belongs_to :token, Token
    belongs_to :wahl, Wahl

    timestamps()
  end

  @doc false
  def changeset(wahl_freigabe, attrs \\ %{}) do
    wahl_freigabe
    |> cast(attrs, [:status, :token_id, :wahl_id])
    |> validate_required([:status, :token_id, :wahl_id])
    |> foreign_key_constraint(:token_id)
    |> foreign_key_constraint(:wahl_id)
    |> unique_constraint([:token_id, :wahl_id])
  end
end
