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
        slug: "some slug"
      })
      |> RbagElections.Wahlen.create_wahl()

    wahl
  end

  @doc """
  Generate a position.
  """
  def position_fixture(attrs \\ %{}) do
    {:ok, position} =
      attrs
      |> Enum.into(%{
        slug: "some slug",
        index: 42
      })
      |> RbagElections.Wahlen.create_position()

    position
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
