defmodule RbagElections.Freigabe do
  @moduledoc """
  The Freigabe context.
  """

  import Ecto.Query, warn: false
  alias RbagElections.Repo

  alias RbagElections.Freigabe.Token

  @doc """
  Returns the list of tokens.

  ## Examples

      iex> list_tokens()
      [%Token{}, ...]

  """
  def list_tokens do
    Repo.all(Token)
  end

  def list_pending_tokens() do
    Token
    |> where(freigegeben: false)
    |> Repo.all()
  end

  def list_confirmed_tokens() do
    Token
    |> where(freigegeben: true)
    |> Repo.all()
  end

  @doc """
  Gets a single token.

  Raises `Ecto.NoResultsError` if the Token does not exist.

  ## Examples

      iex> get_token!(123)
      %Token{}

      iex> get_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_token!(id), do: Repo.get!(Token, id)

  @doc """
  Creates a token.

  ## Examples

      iex> create_token(%{field: value})
      {:ok, %Token{}}

      iex> create_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Confirms a token.

  ## Examples

      iex> confirm_token(token)
      {:ok, %Token{}}

      iex> confirm_token(bad_token)
      {:error, %Ecto.Changeset{}}

  """
  def confirm_token(%Token{} = token) do
    token
    |> Token.changeset(%{freigegeben: true})
    |> Repo.update()
  end

  @doc """
  Revokes a token.

  ## Examples

      iex> revoke_token(token)
      {:ok, %Token{}}

      iex> revoke_token(bad_token})
      {:error, %Ecto.Changeset{}}

  """
  def revoke_token(%Token{} = token) do
    token
    |> Token.changeset(%{freigegeben: false})
    |> Repo.update()
  end

  @doc """
  Deletes a token.

  ## Examples

      iex> delete_token(token)
      {:ok, %Token{}}

      iex> delete_token(token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token(%Token{} = token) do
    Repo.delete(token)
  end

  @doc """
  Deletes a token.

  ## Examples

      iex> delete_token_by_value(value)
      {:ok, %Token{}}

      iex> delete_token_by_value(value)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token_by_value(value) do
    Token
    |> where(value: ^value)
    |> Repo.delete_all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token changes.

  ## Examples

      iex> change_token(token)
      %Ecto.Changeset{data: %Token{}}

  """
  def change_token(%Token{} = token, attrs \\ %{}) do
    Token.changeset(token, attrs)
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_session_token(besitzer) do
    {value, token} = Token.build_session_token(besitzer)
    Repo.insert!(token)
    value
  end

  @doc """
  Gets the token with the given signed value.
  """
  def get_token_by_session_token_value(value) do
    Token
    |> where(value: ^value)
    |> Repo.one()
  end
end
