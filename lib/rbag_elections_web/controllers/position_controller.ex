defmodule RbagElectionsWeb.PositionController do
  use RbagElectionsWeb, :controller

  alias RbagElections.Wahlen
  alias RbagElections.Wahlen.Position

  def index(conn, %{"wahl_slug" => wahl_slug}) do
    positionen = Wahlen.list_positionen(wahl_slug)
    render(conn, :index, wahl_slug: wahl_slug, positionen: positionen)
  end

  def new(conn, %{"wahl_slug" => wahl_slug}) do
    changeset = Wahlen.change_position(%Position{})
    render(conn, :new, wahl_slug: wahl_slug, changeset: changeset)
  end

  def create(conn, %{"wahl_slug" => wahl_slug, "position" => position_params}) do
    case Wahlen.create_position(wahl_slug, position_params) do
      {:ok, position} ->
        conn
        |> put_flash(:info, "Position created successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl_slug}/positionen/#{position}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, wahl_slug: wahl_slug, changeset: changeset)
    end
  end

  def show(conn, %{"wahl_slug" => wahl_slug, "id" => id}) do
    position = Wahlen.get_position!(id)
    render(conn, :show, wahl_slug: wahl_slug, position: position)
  end

  def edit(conn, %{"wahl_slug" => wahl_slug, "id" => id}) do
    position = Wahlen.get_position!(id)
    changeset = Wahlen.change_position(position)
    render(conn, :edit, wahl_slug: wahl_slug, position: position, changeset: changeset)
  end

  def update(conn, %{"wahl_slug" => wahl_slug, "id" => id, "position" => position_params}) do
    position = Wahlen.get_position!(id)

    case Wahlen.update_position(position, position_params) do
      {:ok, position} ->
        conn
        |> put_flash(:info, "Position updated successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl_slug}/positionen/#{position}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, position: position, changeset: changeset)
    end
  end

  def delete(conn, %{"wahl_slug" => wahl_slug, "id" => id}) do
    position = Wahlen.get_position!(id)
    {:ok, _position} = Wahlen.delete_position(position)

    conn
    |> put_flash(:info, "Position deleted successfully.")
    |> redirect(to: ~p"/wahlen/#{wahl_slug}/positionen")
  end
end
