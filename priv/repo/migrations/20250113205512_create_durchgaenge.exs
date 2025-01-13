defmodule RbagElections.Repo.Migrations.CreateDurchgaenge do
  use Ecto.Migration

  def change do
    create table(:durchgaenge) do
      add :status, :string
      add :wahl_id, references(:wahlen, on_delete: :delete_all)
      add :aktuelle_position_id, references(:positionen, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:durchgaenge, [:wahl_id])
  end
end
