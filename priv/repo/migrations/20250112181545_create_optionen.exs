defmodule RbagElections.Repo.Migrations.CreateOptionen do
  use Ecto.Migration

  def change do
    create table(:optionen) do
      add :wert, :string
      add :frage_id, references(:fragen, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:optionen, [:frage_id])
  end
end
