defmodule RbagElections.Repo.Migrations.CreateAbgaben do
  use Ecto.Migration

  def change do
    create table(:abgaben) do
      add :token_id, references(:tokens, on_delete: :delete_all)
      add :abstimmung_id, references(:abstimmungen, on_delete: :delete_all)
    end

    create unique_index(:abgaben, [:token_id, :abstimmung_id])
  end
end
