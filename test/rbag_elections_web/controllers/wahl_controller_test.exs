defmodule RbagElectionsWeb.WahlControllerTest do
  use RbagElectionsWeb.ConnCase

  import RbagElections.WahlenFixtures

  @create_attrs %{slug: "some slug"}
  @update_attrs %{slug: "some updated slug"}
  @invalid_attrs %{slug: nil}

  describe "index" do
    test "lists all wahlen", %{conn: conn} do
      conn = get(conn, ~p"/wahlen")
      assert html_response(conn, 200) =~ "Listing Wahlen"
    end
  end

  describe "new wahl" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/wahlen/new")
      assert html_response(conn, 200) =~ "New Wahl"
    end
  end

  describe "create wahl" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/wahlen", wahl: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/wahlen/#{id}"

      conn = get(conn, ~p"/wahlen/#{id}")
      assert html_response(conn, 200) =~ "Wahl #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/wahlen", wahl: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Wahl"
    end
  end

  describe "edit wahl" do
    setup [:create_wahl]

    test "renders form for editing chosen wahl", %{conn: conn, wahl: wahl} do
      conn = get(conn, ~p"/wahlen/#{wahl}/edit")
      assert html_response(conn, 200) =~ "Edit Wahl"
    end
  end

  describe "update wahl" do
    setup [:create_wahl]

    test "redirects when data is valid", %{conn: conn, wahl: wahl} do
      conn = put(conn, ~p"/wahlen/#{wahl}", wahl: @update_attrs)
      assert redirected_to(conn) == ~p"/wahlen/#{wahl}"

      conn = get(conn, ~p"/wahlen/#{wahl}")
      assert html_response(conn, 200) =~ "some updated slug"
    end

    test "renders errors when data is invalid", %{conn: conn, wahl: wahl} do
      conn = put(conn, ~p"/wahlen/#{wahl}", wahl: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Wahl"
    end
  end

  describe "delete wahl" do
    setup [:create_wahl]

    test "deletes chosen wahl", %{conn: conn, wahl: wahl} do
      conn = delete(conn, ~p"/wahlen/#{wahl}")
      assert redirected_to(conn) == ~p"/wahlen"

      assert_error_sent 404, fn ->
        get(conn, ~p"/wahlen/#{wahl}")
      end
    end
  end

  defp create_wahl(_) do
    wahl = wahl_fixture()
    %{wahl: wahl}
  end
end
