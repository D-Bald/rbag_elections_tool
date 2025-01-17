defmodule RbagElections.Repo.Migrations.CreateAbstimmungen do
  use Ecto.Migration

  def change do
    create table(:abstimmungen) do
      add :wahl_id, references(:wahlen, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:abstimmungen, [:wahl_id])
  end
end
