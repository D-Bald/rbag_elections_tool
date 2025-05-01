defmodule RbagElections.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :value, :binary, null: false
      add :besitzer, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tokens, [:value])
  end
end
