defmodule RbagElectionsWeb.DurchgangLiveTest do
  use RbagElectionsWeb.ConnCase

  import Phoenix.LiveViewTest
  import RbagElections.WahlleitungFixtures

  @create_attrs %{status: "some status"}
  @update_attrs %{status: "some updated status"}
  @invalid_attrs %{status: nil}

  defp create_durchgang(_) do
    durchgang = durchgang_fixture()
    %{durchgang: durchgang}
  end

  describe "Index" do
    setup [:create_durchgang]

    test "lists all durchgaenge", %{conn: conn, durchgang: durchgang} do
      {:ok, _index_live, html} = live(conn, ~p"/durchgaenge")

      assert html =~ "Listing Durchgaenge"
      assert html =~ durchgang.status
    end

    test "saves new durchgang", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/durchgaenge")

      assert index_live |> element("a", "New Durchgang") |> render_click() =~
               "New Durchgang"

      assert_patch(index_live, ~p"/durchgaenge/new")

      assert index_live
             |> form("#durchgang-form", durchgang: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#durchgang-form", durchgang: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/durchgaenge")

      html = render(index_live)
      assert html =~ "Durchgang created successfully"
      assert html =~ "some status"
    end

    test "updates durchgang in listing", %{conn: conn, durchgang: durchgang} do
      {:ok, index_live, _html} = live(conn, ~p"/durchgaenge")

      assert index_live |> element("#durchgaenge-#{durchgang.id} a", "Edit") |> render_click() =~
               "Edit Durchgang"

      assert_patch(index_live, ~p"/durchgaenge/#{durchgang}/edit")

      assert index_live
             |> form("#durchgang-form", durchgang: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#durchgang-form", durchgang: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/durchgaenge")

      html = render(index_live)
      assert html =~ "Durchgang updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes durchgang in listing", %{conn: conn, durchgang: durchgang} do
      {:ok, index_live, _html} = live(conn, ~p"/durchgaenge")

      assert index_live |> element("#durchgaenge-#{durchgang.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#durchgaenge-#{durchgang.id}")
    end
  end

  describe "Show" do
    setup [:create_durchgang]

    test "displays durchgang", %{conn: conn, durchgang: durchgang} do
      {:ok, _show_live, html} = live(conn, ~p"/durchgaenge/#{durchgang}")

      assert html =~ "Show Durchgang"
      assert html =~ durchgang.status
    end

    test "updates durchgang within modal", %{conn: conn, durchgang: durchgang} do
      {:ok, show_live, _html} = live(conn, ~p"/durchgaenge/#{durchgang}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Durchgang"

      assert_patch(show_live, ~p"/durchgaenge/#{durchgang}/show/edit")

      assert show_live
             |> form("#durchgang-form", durchgang: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#durchgang-form", durchgang: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/durchgaenge/#{durchgang}")

      html = render(show_live)
      assert html =~ "Durchgang updated successfully"
      assert html =~ "some updated status"
    end
  end
end
