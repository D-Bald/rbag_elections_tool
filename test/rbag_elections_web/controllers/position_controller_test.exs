defmodule RbagElectionsWeb.PositionControllerTest do
  use RbagElectionsWeb.ConnCase

  import RbagElections.WahlenFixtures

  @create_attrs %{index: 42, beschreibung: "some beschreibung"}
  @update_attrs %{index: 43, beschreibung: "some updated beschreibung"}
  @invalid_attrs %{index: nil, beschreibung: nil}

  describe "index" do
    test "lists all positionen", %{conn: conn} do
      conn = get(conn, ~p"/positionen")
      assert html_response(conn, 200) =~ "Listing Positionen"
    end
  end

  describe "new position" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/positionen/new")
      assert html_response(conn, 200) =~ "New Position"
    end
  end

  describe "create position" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/positionen", position: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/positionen/#{id}"

      conn = get(conn, ~p"/positionen/#{id}")
      assert html_response(conn, 200) =~ "Position #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/positionen", position: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Position"
    end
  end

  describe "edit position" do
    setup [:create_position]

    test "renders form for editing chosen position", %{conn: conn, position: position} do
      conn = get(conn, ~p"/positionen/#{position}/edit")
      assert html_response(conn, 200) =~ "Edit Position"
    end
  end

  describe "update position" do
    setup [:create_position]

    test "redirects when data is valid", %{conn: conn, position: position} do
      conn = put(conn, ~p"/positionen/#{position}", position: @update_attrs)
      assert redirected_to(conn) == ~p"/positionen/#{position}"

      conn = get(conn, ~p"/positionen/#{position}")
      assert html_response(conn, 200) =~ "some updated beschreibung"
    end

    test "renders errors when data is invalid", %{conn: conn, position: position} do
      conn = put(conn, ~p"/positionen/#{position}", position: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Position"
    end
  end

  describe "delete position" do
    setup [:create_position]

    test "deletes chosen position", %{conn: conn, position: position} do
      conn = delete(conn, ~p"/positionen/#{position}")
      assert redirected_to(conn) == ~p"/positionen"

      assert_error_sent 404, fn ->
        get(conn, ~p"/positionen/#{position}")
      end
    end
  end

  defp create_position(_) do
    position = position_fixture()
    %{position: position}
  end
end
