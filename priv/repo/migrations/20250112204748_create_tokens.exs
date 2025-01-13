defmodule RbagElections.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :uuid, :uuid
      add :besitzer, :string
      add :freigegeben, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tokens, [:uuid])
  end
end
