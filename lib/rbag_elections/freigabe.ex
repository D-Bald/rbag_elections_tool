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

  def list_pending_tokens(wahl_slug) do
    list_tokens(wahl_slug, false)
  end

  def list_confirmed_tokens(wahl_slug) do
    list_tokens(wahl_slug, true)
  end

  defp list_tokens(wahl_slug, freigegeben) do
    WahlFreigabe
    |> where(freigegeben: ^freigegeben)
    |> join(:inner, [wf], t in Token, on: wf.token_id == t.id)
    |> join(:inner, [wf], w in Wahl, on: wf.wahl_id == w.id)
    |> where([_, _, w], w.slug == ^wahl_slug)
    |> select([_, t, _], t)
    |> Repo.all()
  end

  def stelle_anfrage_auf_freigabe(token_value, wahl_slug) do
    with {:ok, wahl} <- Wahlen.get_wahl_by_slug(wahl_slug) do
      token = get_token_by_session_token_value(token_value)
      # TODO add error handling: What if token is nil?
      # TODO: do all this in one transaction
      %WahlFreigabe{freigegeben: false, token_id: token.id, wahl_id: wahl.id}
      |> WahlFreigabe.changeset()
      |> Repo.insert()
    end
  end

  @doc """
  Confirms a token.

  ## Examples

      iex> confirm_token_for_wahl(token, wahl)
      {:ok, %Token{}}

      iex> confirm_token_for_wahl(bad_token, bad_wahl)
      {:error, %Ecto.Changeset{}}

  """
  def confirm_token_for_wahl(%Token{} = token, %Wahl{} = wahl) do
    get_wahlfreigabe_by_token_and_wahl!(token, wahl)
    |> WahlFreigabe.changeset(%{freigegeben: true})
    |> Repo.update()
    |> case do
      {:ok, _wahl_freigabe} ->
        broadcast_freigabe_fuer_wahl(token, wahl)
        {:ok, token}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec get_wahlfreigabe_by_token_and_wahl!(
          %RbagElections.Freigabe.Token{id: integer()},
          %RbagElections.Wahlen.Wahl{id: integer()}
        ) :: %RbagElections.Freigabe.WahlFreigabe{}
  defp get_wahlfreigabe_by_token_and_wahl!(%Token{} = token, %Wahl{} = wahl) do
    Repo.get_by!(WahlFreigabe, token_id: token.id, wahl_id: wahl.id)
  end

  defp broadcast_freigabe_fuer_wahl(%Token{} = token, %Wahl{} = wahl) do
    broadcast!(wahl.slug, %Events.FreigabeErteilt{token: token, wahl: wahl})
  end

  defp broadcast!(wahl_slug, msg) do
    Phoenix.PubSub.broadcast!(@pubsub, topic(wahl_slug), msg)
  end

  @spec erteilt?(
          %RbagElections.Freigabe.Token{},
          %RbagElections.Wahlen.Wahl{}
        ) :: boolean()
  def erteilt?(%Token{} = token, %Wahl{} = wahl) do
    wahl_freigabe = get_wahlfreigabe_by_token_and_wahl!(token, wahl)
    wahl_freigabe.freigegeben
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

  def delete_token(%Token{} = token) do
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
