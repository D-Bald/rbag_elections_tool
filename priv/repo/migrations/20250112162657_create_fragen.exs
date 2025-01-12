defmodule RbagElections.Repo.Migrations.CreateFragen do
  use Ecto.Migration

  def change do
    create table(:fragen) do
      add :beschreibung, :string
      add :index, :integer
      add :wahl_id, references(:wahlen, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:fragen, [:wahl_id])
  end
end
