defmodule RbagElections.Submissions.Submission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "submissions" do
    belongs_to :token, RbagElections.Freigabe.Token
    belongs_to :position, RbagElections.Wahlen.Position

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [])
    |> validate_required([:token_id, :position_id])
    |> foreign_key_constraint(:token_id)
    |> foreign_key_constraint(:position_id)
  end
end
