defmodule RbagElections.SubmissionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RbagElections.Submissions` context.
  """

  @doc """
  Generate a submission.
  """
  def submission_fixture(attrs \\ %{}) do
    {:ok, submission} =
      attrs
      |> Enum.into(%{

      })
      |> RbagElections.Submissions.create_submission()

    submission
  end
end
