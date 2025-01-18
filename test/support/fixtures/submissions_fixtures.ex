defmodule RbagElections.AbgabenFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RbagElections.abgaben` context.
  """

  @doc """
  Generate a abgabe.
  """
  def abgabe_fixture(attrs \\ %{}) do
    {:ok, abgabe} =
      attrs
      |> Enum.into(%{})
      |> RbagElections.Abstimmungen.create_abgabe()

    abgabe
  end
end
