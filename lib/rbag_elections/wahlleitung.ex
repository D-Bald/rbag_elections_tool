defmodule RbagElections.Wahlleitung do
  @moduledoc """
  The Wahlleitung context.
  """

  import Ecto.Query, warn: false
  alias RbagElections.Repo

  alias RbagElections.Wahlleitung.Durchgang

  @doc """
  Returns the list of durchgaenge.

  ## Examples

      iex> list_durchgaenge()
      [%Durchgang{}, ...]

  """
  def list_durchgaenge do
    Repo.all(Durchgang)
  end

  @doc """
  Gets a single durchgang.

  Raises `Ecto.NoResultsError` if the Durchgang does not exist.

  ## Examples

      iex> get_durchgang!(123)
      %Durchgang{}

      iex> get_durchgang!(456)
      ** (Ecto.NoResultsError)

  """
  def get_durchgang!(id), do: Repo.get!(Durchgang, id)

  @doc """
  Creates a durchgang.

  ## Examples

      iex> create_durchgang(%{field: value})
      {:ok, %Durchgang{}}

      iex> create_durchgang(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_durchgang(attrs \\ %{}) do
    %Durchgang{}
    |> Durchgang.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a durchgang.

  ## Examples

      iex> update_durchgang(durchgang, %{field: new_value})
      {:ok, %Durchgang{}}

      iex> update_durchgang(durchgang, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_durchgang(%Durchgang{} = durchgang, attrs) do
    durchgang
    |> Durchgang.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a durchgang.

  ## Examples

      iex> delete_durchgang(durchgang)
      {:ok, %Durchgang{}}

      iex> delete_durchgang(durchgang)
      {:error, %Ecto.Changeset{}}

  """
  def delete_durchgang(%Durchgang{} = durchgang) do
    Repo.delete(durchgang)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking durchgang changes.

  ## Examples

      iex> change_durchgang(durchgang)
      %Ecto.Changeset{data: %Durchgang{}}

  """
  def change_durchgang(%Durchgang{} = durchgang, attrs \\ %{}) do
    Durchgang.changeset(durchgang, attrs)
  end
end
