defmodule RbagElections.Freigabe do
  @moduledoc """
  The Freigabe context.
  """

  import Ecto.Query, warn: false
  alias RbagElections.Repo

  alias RbagElections.Freigabe.{Events, Token, WahlFreigabe}
  alias RbagElections.Wahlen
  alias RbagElections.Wahlen.Wahl

  @pubsub RbagElections.PubSub

  def subscribe(wahl_slug) do
    Phoenix.PubSub.subscribe(@pubsub, topic(wahl_slug))
  end

  defp topic(wahl_slug), do: "freigabe:#{wahl_slug}"

  def stelle_anfrage_auf_freigabe(token_value, wahl_slug) do
    with {:ok, wahl} <- Wahlen.get_wahl_by_slug(wahl_slug) do
      token = get_token_by_session_token_value(token_value)
      # TODO add error handling: What if token is nil?
      # TODO: do all this in one transaction
      %WahlFreigabe{token_id: token.id, wahl_id: wahl.id}
      |> WahlFreigabe.changeset()
      |> Repo.insert()
    end
  end

  def list_offene_freigaben(wahl_slug) do
    list_freigaben(wahl_slug, :offen)
  end

  def list_erteilte_freigaben(wahl_slug) do
    list_freigaben(wahl_slug, :erteilt)
  end

  def list_abgelehnte_freigaben(wahl_slug) do
    list_freigaben(wahl_slug, :abgelehnt)
  end

  defp list_freigaben(wahl_slug, status) do
    WahlFreigabe
    |> where(status: ^status)
    |> join(:inner, [wf], w in Wahl, on: wf.wahl_id == w.id)
    |> where([_, w], w.slug == ^wahl_slug)
    |> preload(:token)
    |> Repo.all()
  end

  @doc """
  Confirms a token.

  ## Examples

      iex> erteilen(token, wahl)
      {:ok, %WahlFreigabe{}}

      iex> erteilen(bad_token, bad_wahl)
      {:error, %Ecto.Changeset{}}

  """
  def erteilen(%WahlFreigabe{} = wahl_freigabe) do
    wahl_freigabe
    |> WahlFreigabe.changeset(%{status: :erteilt})
    |> Repo.update()
    |> case do
      {:ok, wahl_freigabe} ->
        broadcast_freigabe_erteilt(wahl_freigabe)
        {:ok, wahl_freigabe}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Revokes a token.

  ## Examples

      iex> revoke_token_for_wahl(token, wahl)
      {:ok, %WahlFreigabe{}}

      iex> revoke_token_for_wahl(bad_token, bad_wahl)
      {:error, %Ecto.Changeset{}}

  """
  def ablehnen(%WahlFreigabe{} = wahl_freigabe) do
    wahl_freigabe
    |> WahlFreigabe.changeset(%{status: :abgelehnt})
    |> Repo.update()
    |> case do
      {:ok, wahl_freigabe} ->
        broadcast_freigabe_abgelehnt(wahl_freigabe)
        {:ok, wahl_freigabe}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp broadcast_freigabe_erteilt(%WahlFreigabe{} = wahl_freigabe) do
    wahl = RbagElections.Wahlen.get_wahl!(wahl_freigabe.wahl_id)
    broadcast!(wahl.slug, %Events.FreigabeErteilt{wahl_freigabe: wahl_freigabe})
  end

  defp broadcast_freigabe_abgelehnt(%WahlFreigabe{} = wahl_freigabe) do
    wahl = RbagElections.Wahlen.get_wahl!(wahl_freigabe.wahl_id)
    broadcast!(wahl.slug, %Events.FreigabeAbgelehnt{wahl_freigabe: wahl_freigabe})
  end

  defp broadcast!(wahl_slug, msg) do
    Phoenix.PubSub.broadcast!(@pubsub, topic(wahl_slug), msg)
  end

  @spec erteilt(
          %RbagElections.Freigabe.Token{},
          %RbagElections.Wahlen.Wahl{}
        ) :: {:ok, boolean()} | {:error, :not_found}
  def erteilt(%Token{} = token, %Wahl{} = wahl) do
    case Repo.get_by(WahlFreigabe, token_id: token.id, wahl_id: wahl.id) do
      nil ->
        {:error, :not_found}

      wahl_freigabe ->
        {:ok, wahl_freigabe.status == :erteilt}
    end
  end

  @doc """
  Deletes a WahlFreigabe.

  ## Examples

      iex> löschen(wahl_freigabe)
      {:ok, %WahlFreigabe{}}

      iex> löschen(bad_wahl_freigabe)
      {:error, %Ecto.Changeset{}}

  """
  def löschen(%WahlFreigabe{} = wahl_freigabe) do
    Repo.delete(wahl_freigabe)
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
    # TODO: Check auf alte tokens (keine freigaben o.ä.), um diese aufzuräumen
    Token
    |> where(value: ^value)
    |> Repo.delete_all()
  end

  def delete_token(%Token{} = token) do
    # TODO: Check auf alte tokens (keine freigaben o.ä.), um diese aufzuräumen
    Repo.delete(token)
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
  @spec get_token_by_session_token_value(binary()) :: %Token{}
  def get_token_by_session_token_value(value) do
    Token
    |> where(value: ^value)
    |> Repo.one()
  end
end
