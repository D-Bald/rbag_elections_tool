defmodule RbagElections.AbstimmungenFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RbagElections.Abstimmungen` context.
  """

  @doc """
  Generate a abstimmung.
  """
  def abstimmung_fixture(attrs \\ %{}) do
    {:ok, abstimmung} =
      attrs
      |> Enum.into(%{

      })
      |> RbagElections.Abstimmungen.create_abstimmung()

    abstimmung
  end

  @doc """
  Generate a stimme.
  """
  def stimme_fixture(attrs \\ %{}) do
    {:ok, stimme} =
      attrs
      |> Enum.into(%{

      })
      |> RbagElections.Abstimmungen.create_stimme()

    stimme
  end
end
