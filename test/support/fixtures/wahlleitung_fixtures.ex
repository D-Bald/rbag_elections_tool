defmodule RbagElections.WahlleitungFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RbagElections.Wahlleitung` context.
  """

  @doc """
  Generate a abstimmung.
  """
  def abstimmung_fixture(attrs \\ %{}) do
    {:ok, abstimmung} =
      attrs
      |> Enum.into(%{
        status: "some status"
      })
      |> RbagElections.Abstimmungen.create_abstimmung()

    abstimmung
  end
end
