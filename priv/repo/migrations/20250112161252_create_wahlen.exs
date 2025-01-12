defmodule RbagElections.Repo.Migrations.CreateWahlen do
  use Ecto.Migration

  def change do
    create table(:wahlen) do
      add :beschreibung, :string

      timestamps(type: :utc_datetime)
    end
  end
end
