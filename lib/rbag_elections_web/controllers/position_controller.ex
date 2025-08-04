defmodule RbagElectionsWeb.PositionController do
  use RbagElectionsWeb, :controller

  alias RbagElections.Wahlen
  alias RbagElections.Wahlen.Position
  alias RbagElections.Abstimmungen

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

  # TODO: Make a new LiveView for this
  def manage_abstimmung(conn, %{"wahl_slug" => wahl_slug}) do
    # TODO: Load all tokens for this Wahl and mark those without a related Abstimmung with red background
    # TODO In the new LiveView: Subscribe to "token:stimme_gezähl" and update background-colors for tokens with submitted Abgaben in realtime
    case Wahlen.get_aktuelle_abstimmung(wahl_slug) do
      {:error, _} ->
        positionen = Wahlen.list_positionen(wahl_slug)
        render(conn, :start_abstimmung, wahl_slug: wahl_slug, positionen: positionen)

      {:ok, abstimmung} ->
        abgaben = Abstimmungen.list_abgaben_for_abstimmung(abstimmung.id)

        render(conn, :manage_abstimmung,
          wahl_slug: wahl_slug,
          abstimmung: abstimmung,
          abgaben: abgaben
        )
    end
  end

  def start_abstimmung(conn, %{"wahl_slug" => wahl_slug, "position_id" => position_id}) do
    {:ok, wahl} = Wahlen.get_wahl_by_slug(wahl_slug)

    case Abstimmungen.start_abstimmung(wahl.id, position_id) do
      {:ok, _abstimmung} ->
        conn
        |> put_flash(:info, "Abstimmung started successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl_slug}/manage_abstimmung")

      {:error, %Ecto.Changeset{} = changeset} ->
        positionen = Wahlen.list_positionen(wahl_slug)

        render(conn, :start_abstimmung,
          wahl_slug: wahl_slug,
          positionen: positionen,
          changeset: changeset
        )
    end
  end

  def end_abstimmung(conn, %{"wahl_slug" => wahl_slug, "abstimmung_id" => abstimmung_id}) do
    case Abstimmungen.end_abstimmung(abstimmung_id) do
      {:ok, _abstimmung} ->
        conn
        |> put_flash(:info, "Abstimmung ended successfully.")
        |> redirect(to: ~p"/wahlen/#{wahl_slug}/manage_abstimmung")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Failed to end Abstimmung.")
        |> redirect(to: ~p"/wahlen/#{wahl_slug}/manage_abstimmung")
    end
  end

  def list_abstimmungen(conn, %{"wahl_slug" => wahl_slug, "position_id" => position_id}) do
    # TODO: Aktuell laufende Abstimmung hier ausschließen, um nicht in Verbindung mit abgegebenen Tokens herauszufinden, wer wie gewählt hat
    abstimmungen = Abstimmungen.list_abstimmungen_for_position(position_id)
    render(conn, :list_abstimmungen, wahl_slug: wahl_slug, abstimmungen: abstimmungen)
  end
end
