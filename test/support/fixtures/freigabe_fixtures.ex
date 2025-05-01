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
    {_value, token } = Token.build_session_token("some besitzer")
    Repo.insert!(token)
  end
end
