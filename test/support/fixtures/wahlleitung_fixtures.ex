defmodule RbagElections.WahlleitungFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RbagElections.Wahlleitung` context.
  """

  @doc """
  Generate a durchgang.
  """
  def durchgang_fixture(attrs \\ %{}) do
    {:ok, durchgang} =
      attrs
      |> Enum.into(%{
        status: "some status"
      })
      |> RbagElections.Wahlleitung.create_durchgang()

    durchgang
  end
end
