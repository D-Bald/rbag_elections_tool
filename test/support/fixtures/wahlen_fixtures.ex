defmodule RbagElections.WahlenFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RbagElections.Wahlen` context.
  """

  @doc """
  Generate a wahl.
  """
  def wahl_fixture(attrs \\ %{}) do
    {:ok, wahl} =
      attrs
      |> Enum.into(%{
        beschreibung: "some beschreibung"
      })
      |> RbagElections.Wahlen.create_wahl()

    wahl
  end

  @doc """
  Generate a frage.
  """
  def frage_fixture(attrs \\ %{}) do
    {:ok, frage} =
      attrs
      |> Enum.into(%{
        beschreibung: "some beschreibung",
        index: 42
      })
      |> RbagElections.Wahlen.create_frage()

    frage
  end

  @doc """
  Generate a option.
  """
  def option_fixture(attrs \\ %{}) do
    {:ok, option} =
      attrs
      |> Enum.into(%{
        wert: "some wert"
      })
      |> RbagElections.Wahlen.create_option()

    option
  end
end
