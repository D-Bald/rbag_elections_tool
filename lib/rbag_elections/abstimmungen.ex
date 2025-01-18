defmodule RbagElections.Abstimmungen do
  @moduledoc """
  The Abstimmungen context.
  """

  import Ecto.Query, warn: false
  alias RbagElections.Repo

  alias RbagElections.Abstimmungen.Abstimmung
  alias RbagElections.Abstimmungen.Abgabe
  alias RbagElections.Wahlen
  alias RbagElections.Wahlen.{Option, Position}
  alias RbagElections.Freigabe.Token

  @doc """
  Returns the list of abstimmungen.

  ## Examples

      iex> list_abstimmungen()
      [%Abstimmung{}, ...]

  """
  def list_abstimmungen do
    Repo.all(Abstimmung)
  end

  def list_abstimmungen_for_position(position_id) do
    Abstimmung
    |> where(position_id: ^position_id)
    |> preload(:position)
    |> Repo.all()
  end

  @doc """
  Gets a single abstimmung.

  Raises `Ecto.NoResultsError` if the Abstimmung does not exist.

  ## Examples

      iex> get_abstimmung!(123)
      %Abstimmung{}

      iex> get_abstimmung!(456)
      ** (Ecto.NoResultsError)

  """
  def get_abstimmung!(id), do: Repo.get!(Abstimmung, id)

  @doc """
  Gets a single abstimmung.

  Raises `Ecto.NoResultsError` if the Abstimmung does not exist.

  ## Examples

      iex> get_abstimmung_by_wahl_slug(some-slug)
      %Abstimmung{}

      iex> get_abstimmung_by_wahl_slug(NoSlug!)
      nil

  """
  def get_abstimmung_by_wahl_slug(wahl_slug) do
    wahl = Wahlen.get_wahl_by_slug!(wahl_slug)

    case Repo.get_by(Abstimmung, wahl_id: wahl.id) do
      nil -> {:error, "No Abstimmung found for Wahl with slug #{wahl_slug}"}
      abstimmung -> {:ok, abstimmung}
    end
  end

  @doc """
  Creates a abstimmung. And therefore starts it.

  ## Examples

      iex> create_abstimmung(%{field: value})
      {:ok, %Abstimmung{}}

      iex> create_abstimmung(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp create_abstimmung(attrs \\ %{}) do
    %Abstimmung{}
    |> Abstimmung.changeset(attrs)
    |> Repo.insert()
  end

  def start_abstimmung(wahl_id, position_id) do
    create_abstimmung(%{wahl_id: wahl_id, position_id: position_id})
  end

  @doc """
  Removes the link to the wahl which effectively ends the abstimmung.

  ## Examples

      iex> end_abstimmung(%{field: value})
      {:ok, %Abstimmung{}}

      iex> end_abstimmung(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def end_abstimmung(abstimmung_id) do
    Repo.get!(Abstimmung, abstimmung_id)
    |> Abstimmung.changeset(%{wahl_id: nil})
    |> Repo.update()
  end

  @doc """
  Updates a abstimmung.

  ## Examples

      iex> update_abstimmung(abstimmung, %{field: new_value})
      {:ok, %Abstimmung{}}

      iex> update_abstimmung(abstimmung, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_abstimmung(%Abstimmung{} = abstimmung, attrs) do
    abstimmung
    |> Abstimmung.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a abstimmung.

  ## Examples

      iex> delete_abstimmung(abstimmung)
      {:ok, %Abstimmung{}}

      iex> delete_abstimmung(abstimmung)
      {:error, %Ecto.Changeset{}}

  """
  def delete_abstimmung(%Abstimmung{} = abstimmung) do
    Repo.delete(abstimmung)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking abstimmung changes.

  ## Examples

      iex> change_abstimmung(abstimmung)
      %Ecto.Changeset{data: %Abstimmung{}}

  """
  def change_abstimmung(%Abstimmung{} = abstimmung, attrs \\ %{}) do
    Abstimmung.changeset(abstimmung, attrs)
  end

  @doc """
  Returns the list of Abstimmungen.

  ## Examples

      iex> list_Abstimmungen
      [%Abgabe{}, ...]

  """
  def list_abgaben do
    Abgabe
    |> preload(token: [:besitzer], position: [:beschreibung])
    |> Repo.all()
  end

  def list_abgaben_for_abstimmung(abstimmung_id) do
    Abgabe
    |> where(abstimmung_id: ^abstimmung_id)
    |> preload(token: [], abstimmung: [:position])
    |> Repo.all()
  end

  @spec get_abgabe!(any()) :: any()
  @doc """
  Gets a single abgabe.

  Raises `Ecto.NoResultsError` if the Abgabe does not exist.

  ## Examples

      iex> get_abgabe!(123)
      %Abgabe{}

      iex> get_abgabe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_abgabe!(id), do: Repo.get!(Abgabe, id)

  @doc """
  Creates a abgabe.

  ## Examples

      iex> create_abgabe(%{field: value})
      {:ok, %Abgabe{}}

      iex> create_abgabe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_abgabe(attrs \\ %{}) do
    %Abgabe{}
    |> Abgabe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a abgabe.

  ## Examples

      iex> update_abgabe(abgabe, %{field: new_value})
      {:ok, %Abgabe{}}

      iex> update_abgabe(abgabe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_abgabe(%Abgabe{} = abgabe, attrs) do
    abgabe
    |> Abgabe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a abgabe.

  ## Examples

      iex> delete_abgabe(abgabe)
      {:ok, %Abgabe{}}

      iex> delete_abgabe(abgabe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_abgabe(%Abgabe{} = abgabe) do
    Repo.delete(abgabe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking abgabe changes.

  ## Examples

      iex> change_abgabe(abgabe)
      %Ecto.Changeset{data: %Abgabe{}}

  """
  def change_abgabe(%Abgabe{} = abgabe, attrs \\ %{}) do
    Abgabe.changeset(abgabe, attrs)
  end

  alias RbagElections.Abstimmungen.Stimme

  @doc """
  Returns the list of stimmen.

  ## Examples

      iex> list_stimmen()
      [%Stimme{}, ...]

  """
  def list_stimmen do
    Repo.all(Stimme)
  end

  @doc """
  Gets a single stimme.

  Raises `Ecto.NoResultsError` if the Stimme does not exist.

  ## Examples

      iex> get_stimme!(123)
      %Stimme{}

      iex> get_stimme!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stimme!(id), do: Repo.get!(Stimme, id)

  @doc """
  Creates a stimme.

  ## Examples

      iex> create_stimme(%{field: value})
      {:ok, %Stimme{}}

      iex> create_stimme(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stimme(attrs \\ %{}) do
    %Stimme{}
    |> Stimme.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stimme.

  ## Examples

      iex> update_stimme(stimme, %{field: new_value})
      {:ok, %Stimme{}}

      iex> update_stimme(stimme, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stimme(%Stimme{} = stimme, attrs) do
    stimme
    |> Stimme.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stimme.

  ## Examples

      iex> delete_stimme(stimme)
      {:ok, %Stimme{}}

      iex> delete_stimme(stimme)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stimme(%Stimme{} = stimme) do
    Repo.delete(stimme)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stimme changes.

  ## Examples

      iex> change_stimme(stimme)
      %Ecto.Changeset{data: %Stimme{}}

  """
  def change_stimme(%Stimme{} = stimme, attrs \\ %{}) do
    Stimme.changeset(stimme, attrs)
  end

  def submit(wahl_slug, %Option{} = option, %Token{} = token) when is_binary(wahl_slug) do
    case get_abstimmung_by_wahl_slug(wahl_slug) do
      {:error, reason} -> {:error, reason}
      {:ok, abstimmung} -> submit(abstimmung, option, token)
    end
  end

  def submit(%Abstimmung{} = abstimmung, %Option{} = option, %Token{} = token) do
    # TODO: Make this nicer with https://hexdocs.pm/ecto/Ecto.Multi.html
    Repo.transaction(fn ->
      case create_abgabe(%{
             abstimmung_id: abstimmung.id,
             token_id: token.id
           }) do
        {:ok, _abgabe} ->
          case create_stimme(%{
                 abstimmung_id: abstimmung.id,
                 option_id: option.id
               }) do
            {:ok, stimme} ->
              {:ok, stimme}

            {:error, changeset} ->
              Repo.rollback(changeset)
          end

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  @doc """
  Aggregates stimmen by option.
  """
  def aggregate_stimmen_by_option(abstimmung_id) do
    Stimme
    |> where([s], s.abstimmung_id == ^abstimmung_id)
    |> join(:inner, [s], o in assoc(s, :option))
    |> group_by([s, o], [o.id, o.wert, o.position_id, o.inserted_at, o.updated_at])
    |> select([s, o], %{option: o, count: count(s.id)})
    |> Repo.all()
    |> IO.inspect()
  end

  def get_position_with_options(abstimmung_id) do
    abstimmung = get_abstimmung!(abstimmung_id)

    Position
    |> where([p], p.id == ^abstimmung.position_id)
    |> preload(:optionen)
    |> Repo.one()
  end
end
