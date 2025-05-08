defmodule RbagElections.Repo.Migrations.CreateOptionen do
  use Ecto.Migration

  def change do
    create table(:optionen) do
      add :wert, :string, null: false
      add :position_id, references(:positionen, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:optionen, [:position_id])
  end
end
