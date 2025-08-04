defmodule RbagElections.Abstimmungen.Stimme do
  use Ecto.Schema
  import Ecto.Changeset

  @type id :: binary()
  @type t :: %__MODULE__{
          id: id() | nil,
          abstimmung_id: RbagElections.Abstimmungen.Abstimmung.id() | nil,
          abstimmung:
            RbagElections.Abstimmungen.Abstimmung.t() | Ecto.Association.NotLoaded.t() | nil,
          option_id: RbagElections.Wahlen.Option.id() | nil,
          option: RbagElections.Wahlen.Option.t() | Ecto.Association.NotLoaded.t() | nil
        }

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "stimmen" do
    belongs_to :abstimmung, RbagElections.Abstimmungen.Abstimmung
    belongs_to :option, RbagElections.Wahlen.Option
  end

  @doc false
  def changeset(stimme, attrs) do
    stimme
    |> cast(attrs, [:abstimmung_id, :option_id])
    |> validate_required([:abstimmung_id, :option_id])
    |> foreign_key_constraint(:abstimmung_id)
    |> foreign_key_constraint(:option_id)
  end
end
