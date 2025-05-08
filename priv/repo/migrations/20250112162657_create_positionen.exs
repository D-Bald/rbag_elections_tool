defmodule RbagElections.Repo.Migrations.CreatePositionen do
  use Ecto.Migration

  def change do
    create table(:positionen) do
      add :name, :string, null: false
      add :wahl_id, references(:wahlen, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:positionen, [:wahl_id])
  end
end
