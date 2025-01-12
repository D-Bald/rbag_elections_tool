defmodule RbagElectionsWeb.OptionControllerTest do
  use RbagElectionsWeb.ConnCase

  import RbagElections.WahlenFixtures

  @create_attrs %{wert: "some wert"}
  @update_attrs %{wert: "some updated wert"}
  @invalid_attrs %{wert: nil}

  describe "index" do
    test "lists all optionen", %{conn: conn} do
      conn = get(conn, ~p"/optionen")
      assert html_response(conn, 200) =~ "Listing Optionen"
    end
  end

  describe "new option" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/optionen/new")
      assert html_response(conn, 200) =~ "New Option"
    end
  end

  describe "create option" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/optionen", option: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/optionen/#{id}"

      conn = get(conn, ~p"/optionen/#{id}")
      assert html_response(conn, 200) =~ "Option #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/optionen", option: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Option"
    end
  end

  describe "edit option" do
    setup [:create_option]

    test "renders form for editing chosen option", %{conn: conn, option: option} do
      conn = get(conn, ~p"/optionen/#{option}/edit")
      assert html_response(conn, 200) =~ "Edit Option"
    end
  end

  describe "update option" do
    setup [:create_option]

    test "redirects when data is valid", %{conn: conn, option: option} do
      conn = put(conn, ~p"/optionen/#{option}", option: @update_attrs)
      assert redirected_to(conn) == ~p"/optionen/#{option}"

      conn = get(conn, ~p"/optionen/#{option}")
      assert html_response(conn, 200) =~ "some updated wert"
    end

    test "renders errors when data is invalid", %{conn: conn, option: option} do
      conn = put(conn, ~p"/optionen/#{option}", option: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Option"
    end
  end

  describe "delete option" do
    setup [:create_option]

    test "deletes chosen option", %{conn: conn, option: option} do
      conn = delete(conn, ~p"/optionen/#{option}")
      assert redirected_to(conn) == ~p"/optionen"

      assert_error_sent 404, fn ->
        get(conn, ~p"/optionen/#{option}")
      end
    end
  end

  defp create_option(_) do
    option = option_fixture()
    %{option: option}
  end
end
