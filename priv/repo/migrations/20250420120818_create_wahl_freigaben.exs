defmodule RbagElections.Repo.Migrations.CreateWahlenTokens do
  use Ecto.Migration

  def change do
    create table(:wahl_freigaben) do
      add :freigegeben, :boolean, default: false, null: false
      add :wahl_id, references(:wahlen)
      add :token_id, references(:tokens)

      timestamps(type: :utc_datetime)
    end

    create index(:wahl_freigaben, [:wahl_id])
    create index(:wahl_freigaben, [:token_id])
    create unique_index(:wahl_freigaben, [:wahl_id, :token_id])
  end
end
