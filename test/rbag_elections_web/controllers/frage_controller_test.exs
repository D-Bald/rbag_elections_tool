defmodule RbagElectionsWeb.FrageControllerTest do
  use RbagElectionsWeb.ConnCase

  import RbagElections.WahlenFixtures

  @create_attrs %{index: 42, beschreibung: "some beschreibung"}
  @update_attrs %{index: 43, beschreibung: "some updated beschreibung"}
  @invalid_attrs %{index: nil, beschreibung: nil}

  describe "index" do
    test "lists all fragen", %{conn: conn} do
      conn = get(conn, ~p"/fragen")
      assert html_response(conn, 200) =~ "Listing Fragen"
    end
  end

  describe "new frage" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/fragen/new")
      assert html_response(conn, 200) =~ "New Frage"
    end
  end

  describe "create frage" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/fragen", frage: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/fragen/#{id}"

      conn = get(conn, ~p"/fragen/#{id}")
      assert html_response(conn, 200) =~ "Frage #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/fragen", frage: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Frage"
    end
  end

  describe "edit frage" do
    setup [:create_frage]

    test "renders form for editing chosen frage", %{conn: conn, frage: frage} do
      conn = get(conn, ~p"/fragen/#{frage}/edit")
      assert html_response(conn, 200) =~ "Edit Frage"
    end
  end

  describe "update frage" do
    setup [:create_frage]

    test "redirects when data is valid", %{conn: conn, frage: frage} do
      conn = put(conn, ~p"/fragen/#{frage}", frage: @update_attrs)
      assert redirected_to(conn) == ~p"/fragen/#{frage}"

      conn = get(conn, ~p"/fragen/#{frage}")
      assert html_response(conn, 200) =~ "some updated beschreibung"
    end

    test "renders errors when data is invalid", %{conn: conn, frage: frage} do
      conn = put(conn, ~p"/fragen/#{frage}", frage: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Frage"
    end
  end

  describe "delete frage" do
    setup [:create_frage]

    test "deletes chosen frage", %{conn: conn, frage: frage} do
      conn = delete(conn, ~p"/fragen/#{frage}")
      assert redirected_to(conn) == ~p"/fragen"

      assert_error_sent 404, fn ->
        get(conn, ~p"/fragen/#{frage}")
      end
    end
  end

  defp create_frage(_) do
    frage = frage_fixture()
    %{frage: frage}
  end
end
