defmodule RbagElections.Wahlen do
  @moduledoc """
  The Wahlen context.
  """

  import Ecto.Query, warn: false
  alias RbagElections.Repo

  alias RbagElections.Wahlen.Wahl

  @doc """
  Returns the list of wahlen.

  ## Examples

      iex> list_wahlen()
      [%Wahl{}, ...]

  """
  def list_wahlen do
    Repo.all(Wahl)
  end

  @doc """
  Gets a single wahl.

  Raises `Ecto.NoResultsError` if the Wahl does not exist.

  ## Examples

      iex> get_wahl!(123)
      %Wahl{}

      iex> get_wahl!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wahl!(id), do: Repo.get!(Wahl, id)

  @doc """
  Creates a wahl.

  ## Examples

      iex> create_wahl(%{field: value})
      {:ok, %Wahl{}}

      iex> create_wahl(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wahl(attrs \\ %{}) do
    %Wahl{}
    |> Wahl.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wahl.

  ## Examples

      iex> update_wahl(wahl, %{field: new_value})
      {:ok, %Wahl{}}

      iex> update_wahl(wahl, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wahl(%Wahl{} = wahl, attrs) do
    wahl
    |> Wahl.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wahl.

  ## Examples

      iex> delete_wahl(wahl)
      {:ok, %Wahl{}}

      iex> delete_wahl(wahl)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wahl(%Wahl{} = wahl) do
    Repo.delete(wahl)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wahl changes.

  ## Examples

      iex> change_wahl(wahl)
      %Ecto.Changeset{data: %Wahl{}}

  """
  def change_wahl(%Wahl{} = wahl, attrs \\ %{}) do
    Wahl.changeset(wahl, attrs)
  end

  alias RbagElections.Wahlen.Frage

  @doc """
  Returns the list of fragen.

  ## Examples

      iex> list_fragen()
      [%Frage{}, ...]

  """
  def list_fragen(wahl_id) do
    Frage
    |> where(wahl_id: ^wahl_id)
    |> Repo.all()
  end

  @doc """
  Gets a single frage.

  Raises `Ecto.NoResultsError` if the Frage does not exist.

  ## Examples

      iex> get_frage!(123)
      %Frage{}

      iex> get_frage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_frage!(id), do: Repo.get!(Frage, id)

  @doc """
  Creates a frage.

  ## Examples

      iex> create_frage(%{field: value})
      {:ok, %Frage{}}

      iex> create_frage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_frage(wahl_id, attrs \\ %{}) when is_integer(wahl_id) do
    %Frage{wahl_id: wahl_id}
    |> Frage.changeset(attrs)
    |> IO.inspect()
    |> Repo.insert()
  end

  @doc """
  Updates a frage.

  ## Examples

      iex> update_frage(frage, %{field: new_value})
      {:ok, %Frage{}}

      iex> update_frage(frage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_frage(%Frage{} = frage, attrs) do
    frage
    |> Frage.changeset(attrs)
    |> Repo.update()
    |> IO.inspect()
  end

  @doc """
  Deletes a frage.

  ## Examples

      iex> delete_frage(frage)
      {:ok, %Frage{}}

      iex> delete_frage(frage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_frage(%Frage{} = frage) do
    Repo.delete(frage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking frage changes.

  ## Examples

      iex> change_frage(frage)
      %Ecto.Changeset{data: %Frage{}}

  """
  def change_frage(%Frage{} = frage, attrs \\ %{}) do
    Frage.changeset(frage, attrs)
  end

  alias RbagElections.Wahlen.Option

  @doc """
  Returns the list of optionen.

  ## Examples

      iex> list_optionen()
      [%Option{}, ...]

  """
  def list_optionen(frage_id) do
    Option
    |> where(frage_id: ^frage_id)
    |> Repo.all()
  end

  @doc """
  Gets a single option.

  Raises `Ecto.NoResultsError` if the Option does not exist.

  ## Examples

      iex> get_option!(123)
      %Option{}

      iex> get_option!(456)
      ** (Ecto.NoResultsError)

  """
  def get_option!(id), do: Repo.get!(Option, id)

  @doc """
  Creates a option.

  ## Examples

      iex> create_option(%{field: value})
      {:ok, %Option{}}

      iex> create_option(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_option(frage_id, attrs \\ %{}) when is_integer(frage_id) do
    %Option{frage_id: frage_id}
    |> Option.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a option.

  ## Examples

      iex> update_option(option, %{field: new_value})
      {:ok, %Option{}}

      iex> update_option(option, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_option(%Option{} = option, attrs) do
    option
    |> Option.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a option.

  ## Examples

      iex> delete_option(option)
      {:ok, %Option{}}

      iex> delete_option(option)
      {:error, %Ecto.Changeset{}}

  """
  def delete_option(%Option{} = option) do
    Repo.delete(option)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking option changes.

  ## Examples

      iex> change_option(option)
      %Ecto.Changeset{data: %Option{}}

  """
  def change_option(%Option{} = option, attrs \\ %{}) do
    Option.changeset(option, attrs)
  end
end
