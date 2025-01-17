defmodule RbagElections.Wahlen.Wahl do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :slug}
  schema "wahlen" do
    field :slug, :string

    has_one :aktuelle_abstimmung, RbagElections.Abstimmungen.Abstimmung, foreign_key: :wahl_id

    has_many :positionen, RbagElections.Wahlen.Position

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wahl, attrs) do
    wahl
    |> cast(attrs, [:slug])
    |> validate_required([:slug])
    |> validate_slug(:slug)
  end

  defp validate_slug(changeset, field) do
    validate_change(changeset, field, fn _, value ->
      if Regex.match?(~r/^[a-z0-9]+(?:-[a-z0-9]+)*$/, value) do
        []
      else
        [
          {field,
           "must be a valid slug (lowercase, no punctuation, whitespace replaced by hyphens)"}
        ]
      end
    end)
  end
end
