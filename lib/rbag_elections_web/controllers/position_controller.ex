defmodule RbagElectionsWeb.PositionController do
  use RbagElectionsWeb, :controller

  alias RbagElections.Wahlen
  alias RbagElections.Wahlen.Position

  def index(conn, %{"wahl_id" => wahl_id}) do
    positionen = Wahlen.list_positionen(wahl_id)
    render(conn, :index, wahl_id: wahl_id, positionen: positionen)
  end

  def new(conn, %{"wahl_id" => wahl_id}) do
    changeset = Wahlen.change_position(%Position{})
    render(conn, :new, wahl_id: wahl_id, changeset: changeset)
  end

  def create(conn, %{"wahl_id" => wahl_id, "position" => position_params}) do
    case Wahlen.create_position(String.to_integer(wahl_id), position_params) do
      {:ok, position} ->
        conn
        |> put_flash(:info, "Position created successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl_id}/positionen/#{position}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, wahl_id: wahl_id, changeset: changeset)
    end
  end

  def show(conn, %{"wahl_id" => wahl_id, "id" => id}) do
    position = Wahlen.get_position!(id)
    render(conn, :show, wahl_id: wahl_id, position: position)
  end

  def edit(conn, %{"wahl_id" => wahl_id, "id" => id}) do
    position = Wahlen.get_position!(id)
    changeset = Wahlen.change_position(position)
    render(conn, :edit, wahl_id: wahl_id, position: position, changeset: changeset)
  end

  def update(conn, %{"wahl_id" => wahl_id, "id" => id, "position" => position_params}) do
    position = Wahlen.get_position!(id)

    case Wahlen.update_position(position, position_params) do
      {:ok, position} ->
        conn
        |> put_flash(:info, "Position updated successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl_id}/positionen/#{position}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, position: position, changeset: changeset)
    end
  end

  def delete(conn, %{"wahl_id" => wahl_id, "id" => id}) do
    position = Wahlen.get_position!(id)
    {:ok, _position} = Wahlen.delete_position(position)

    conn
    |> put_flash(:info, "Position deleted successfully.")
    |> redirect(to: ~p"/wahlen/#{wahl_id}/positionen")
  end
end
