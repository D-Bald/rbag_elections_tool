defmodule RbagElectionsWeb.FrageController do
  use RbagElectionsWeb, :controller

  alias RbagElections.Wahlen
  alias RbagElections.Wahlen.Frage

  def index(conn, %{"wahl_id" => wahl_id}) do
    fragen = Wahlen.list_fragen(wahl_id)
    render(conn, :index, wahl_id: wahl_id, fragen: fragen)
  end

  def new(conn, %{"wahl_id" => wahl_id}) do
    changeset = Wahlen.change_frage(%Frage{})
    render(conn, :new, wahl_id: wahl_id, changeset: changeset)
  end

  def create(conn, %{"wahl_id" => wahl_id, "frage" => frage_params}) do
    case Wahlen.create_frage(String.to_integer(wahl_id), frage_params) do
      {:ok, frage} ->
        conn
        |> put_flash(:info, "Frage created successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl_id}/fragen/#{frage}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, wahl_id: wahl_id, changeset: changeset)
    end
  end

  def show(conn, %{"wahl_id" => wahl_id, "id" => id}) do
    frage = Wahlen.get_frage!(id)
    render(conn, :show, wahl_id: wahl_id, frage: frage)
  end

  def edit(conn, %{"wahl_id" => wahl_id, "id" => id}) do
    frage = Wahlen.get_frage!(id)
    changeset = Wahlen.change_frage(frage)
    render(conn, :edit, wahl_id: wahl_id, frage: frage, changeset: changeset)
  end

  def update(conn, %{"wahl_id" => wahl_id, "id" => id, "frage" => frage_params}) do
    frage = Wahlen.get_frage!(id)

    case Wahlen.update_frage(frage, frage_params) do
      {:ok, frage} ->
        conn
        |> put_flash(:info, "Frage updated successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl_id}/fragen/#{frage}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, frage: frage, changeset: changeset)
    end
  end

  def delete(conn, %{"wahl_id" => wahl_id, "id" => id}) do
    frage = Wahlen.get_frage!(id)
    {:ok, _frage} = Wahlen.delete_frage(frage)

    conn
    |> put_flash(:info, "Frage deleted successfully.")
    |> redirect(to: ~p"/wahlen/#{wahl_id}/fragen")
  end
end
