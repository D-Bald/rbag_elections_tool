defmodule RbagElections.Repo.Migrations.CreateWahlen do
  use Ecto.Migration

  def change do
    create table(:wahlen) do
      add :slug, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:wahlen, [:slug])
  end
end
