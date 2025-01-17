defmodule RbagElectionsWeb.WahlController do
  use RbagElectionsWeb, :controller

  alias RbagElections.Wahlen
  alias RbagElections.Wahlen.Wahl

  def index(conn, _params) do
    wahlen = Wahlen.list_wahlen()
    render(conn, :index, wahlen: wahlen)
  end

  def new(conn, _params) do
    changeset = Wahlen.change_wahl(%Wahl{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"wahl" => wahl_params}) do
    case Wahlen.create_wahl(wahl_params) do
      {:ok, wahl} ->
        conn
        |> put_flash(:info, "Wahl created successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug}) do
    wahl = Wahlen.get_wahl_by_slug!(slug)
    render(conn, :show, wahl: wahl)
  end

  def edit(conn, %{"slug" => slug}) do
    wahl = Wahlen.get_wahl_by_slug!(slug)
    changeset = Wahlen.change_wahl(wahl)
    render(conn, :edit, wahl: wahl, changeset: changeset)
  end

  def update(conn, %{"slug" => slug, "wahl" => wahl_params}) do
    wahl = Wahlen.get_wahl_by_slug!(slug)

    case Wahlen.update_wahl(wahl, wahl_params) do
      {:ok, wahl} ->
        conn
        |> put_flash(:info, "Wahl updated successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, wahl: wahl, changeset: changeset)
    end
  end

  def delete(conn, %{"slug" => slug}) do
    wahl = Wahlen.get_wahl_by_slug!(slug)
    {:ok, _wahl} = Wahlen.delete_wahl(wahl)

    conn
    |> put_flash(:info, "Wahl deleted successfully.")
    |> redirect(to: ~p"/wahlen")
  end
end
