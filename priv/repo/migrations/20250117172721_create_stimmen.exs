defmodule RbagElections.Repo.Migrations.CreateStimmen do
  use Ecto.Migration

  def change do
    create table(:stimmen) do
      add :abstimmung_id, references(:abstimmungen, on_delete: :delete_all)
      add :option_id, references(:optionen, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:stimmen, [:abstimmung_id, :option_id])
  end
end
