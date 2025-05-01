defmodule RbagElections.Abstimmungen.Stimme do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stimmen" do
    @primary_key {:id, :binary_id, autogenerate: true}
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
