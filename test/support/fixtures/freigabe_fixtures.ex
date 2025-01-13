defmodule RbagElections.FreigabeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RbagElections.Freigabe` context.
  """

  @doc """
  Generate a unique token uuid.
  """
  def unique_token_uuid do
    raise "implement the logic to generate a unique token uuid"
  end

  @doc """
  Generate a token.
  """
  def token_fixture(attrs \\ %{}) do
    {:ok, token} =
      attrs
      |> Enum.into(%{
        besitzer: "some besitzer",
        freigegeben: true,
        uuid: unique_token_uuid()
      })
      |> RbagElections.Freigabe.create_token()

    token
  end
end
