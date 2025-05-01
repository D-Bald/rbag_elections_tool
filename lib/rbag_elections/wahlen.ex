defmodule RbagElections.Wahlen do
  @moduledoc """
  The Wahlen context.
  """

  import Ecto.Query, warn: false

  alias RbagElections.Repo
  alias RbagElections.Wahlen.Wahl
  alias RbagElections.Abstimmungen

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
  Gets a single wahl by slug.

  Raises `Ecto.NoResultsError` if the Wahl does not exist.

  ## Examples

      iex> get_wahl_by_slug("some-slug")
      {:ok, %Wahl{}}

      iex> get_wahl_by_slug("non-existent-slug")
      {:error, "Wahl with slug non-existent-slug not found"}

  """
  def get_wahl_by_slug(slug) do
    case Repo.get_by(Wahl, slug: slug) do
      nil -> {:error, "Wahl with slug #{slug} not found"}
      wahl -> {:ok, wahl}
    end
  end

  def get_aktuelle_abstimmung(wahl_slug) do
    with {:ok, wahl} <- get_wahl_by_slug(wahl_slug) do
      Abstimmungen.get_aktuelle_abstimmung(wahl)
    end
  end

  def get_aktuelle_abstimmung_with_position_and_options(wahl_slug) do
    with {:ok, wahl} <- get_wahl_by_slug(wahl_slug) do
      Abstimmungen.get_aktuelle_abstimmung_with_position_and_options(wahl)
    end
  end

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

  alias RbagElections.Wahlen.Position

  @doc """
  Returns the list of positionen.

  ## Examples

      iex> list_positionen()
      [%Position{}, ...]

  """
  def list_positionen(wahl_slug) do
    with {:ok, wahl} <- get_wahl_by_slug(wahl_slug) do
      Position
      |> where(wahl_id: ^wahl.id)
      |> Repo.all()
    end
  end

  @doc """
  Gets a single position.

  Raises `Ecto.NoResultsError` if the Position does not exist.

  ## Examples

      iex> get_position!(123)
      %Position{}

      iex> get_position!(456)
      ** (Ecto.NoResultsError)

  """
  def get_position!(id), do: Repo.get!(Position, id)

  @doc """
  Creates a position.

  ## Examples

      iex> create_position(%{field: value})
      {:ok, %Position{}}

      iex> create_position(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_position(wahl_slug, attrs \\ %{}) do
    with {:ok, wahl} <- get_wahl_by_slug(wahl_slug) do
      %Position{wahl_id: wahl.id}
      |> Position.changeset(attrs)
      |> Repo.insert()
    end
  end

  @doc """
  Updates a position.

  ## Examples

      iex> update_position(position, %{field: new_value})
      {:ok, %Position{}}

      iex> update_position(position, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_position(%Position{} = position, attrs) do
    position
    |> Position.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a position.

  ## Examples

      iex> delete_position(position)
      {:ok, %Position{}}

      iex> delete_position(position)
      {:error, %Ecto.Changeset{}}

  """
  def delete_position(%Position{} = position) do
    Repo.delete(position)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking position changes.

  ## Examples

      iex> change_position(position)
      %Ecto.Changeset{data: %Position{}}

  """
  def change_position(%Position{} = position, attrs \\ %{}) do
    Position.changeset(position, attrs)
  end

  alias RbagElections.Wahlen.Option

  @doc """
  Returns the list of optionen.

  ## Examples

      iex> list_optionen()
      [%Option{}, ...]

  """
  def list_optionen(position_id) do
    Option
    |> where(position_id: ^position_id)
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
  def create_option(position_id, attrs \\ %{}) when is_integer(position_id) do
    %Option{position_id: position_id}
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
