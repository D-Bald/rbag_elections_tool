defmodule RbagElections.Wahlleitung.Durchgang do
  use Ecto.Schema
  import Ecto.Changeset

  schema "durchgaenge" do
    field :status, Ecto.Enum, values: [:warten, :stimmabgabe, :ergebnis], default: :warten

    belongs_to :wahl, RbagElections.Wahlen.Wahl

    belongs_to :aktuelle_position, RbagElections.Wahlen.Position,
      foreign_key: :aktuelle_position_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(durchgang, attrs) do
    durchgang
    |> cast(attrs, [:status])
    |> validate_required([:wahl_id, :status])
  end
end
