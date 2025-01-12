defmodule RbagElectionsWeb.OptionController do
  use RbagElectionsWeb, :controller

  alias RbagElections.Wahlen
  alias RbagElections.Wahlen.Option

  def index(conn, %{"wahl_id" => wahl_id, "position_id" => position_id}) do
    optionen = Wahlen.list_optionen(position_id)
    render(conn, :index, wahl_id: wahl_id, position_id: position_id, optionen: optionen)
  end

  def new(conn, %{"wahl_id" => wahl_id, "position_id" => position_id}) do
    changeset = Wahlen.change_option(%Option{})
    render(conn, :new, wahl_id: wahl_id, position_id: position_id, changeset: changeset)
  end

  def create(conn, %{
        "wahl_id" => wahl_id,
        "position_id" => position_id,
        "option" => option_params
      }) do
    case Wahlen.create_option(String.to_integer(position_id), option_params) do
      {:ok, option} ->
        conn
        |> put_flash(:info, "Option created successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl_id}/positionen/#{position_id}/optionen/#{option}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, wahl_id: wahl_id, position_id: position_id, changeset: changeset)
    end
  end

  def show(conn, %{"wahl_id" => wahl_id, "position_id" => position_id, "id" => id}) do
    option = Wahlen.get_option!(id)
    render(conn, :show, wahl_id: wahl_id, position_id: position_id, option: option)
  end

  def edit(conn, %{"wahl_id" => wahl_id, "position_id" => position_id, "id" => id}) do
    option = Wahlen.get_option!(id)
    changeset = Wahlen.change_option(option)

    render(conn, :edit,
      wahl_id: wahl_id,
      position_id: position_id,
      option: option,
      changeset: changeset
    )
  end

  def update(conn, %{
        "wahl_id" => wahl_id,
        "position_id" => position_id,
        "id" => id,
        "option" => option_params
      }) do
    option = Wahlen.get_option!(id)

    case Wahlen.update_option(option, option_params) do
      {:ok, option} ->
        conn
        |> put_flash(:info, "Option updated successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl_id}/positionen/#{position_id}/optionen/#{option}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit,
          wahl_id: wahl_id,
          position_id: position_id,
          option: option,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"wahl_id" => wahl_id, "position_id" => position_id, "id" => id}) do
    option = Wahlen.get_option!(id)
    {:ok, _option} = Wahlen.delete_option(option)

    conn
    |> put_flash(:info, "Option deleted successfully.")
    |> redirect(to: ~p"/wahlen/#{wahl_id}/positionen/#{position_id}/optionen")
  end
end
