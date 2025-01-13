defmodule RbagElections.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :token_id, references(:tokens, on_delete: :delete_all)
      add :position_id, references(:positionen, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:submissions, [:token_id, :position_id])
  end
end
