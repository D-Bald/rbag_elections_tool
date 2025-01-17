defmodule RbagElectionsWeb.abgabeLiveTest() do
  use RbagElectionsWeb.ConnCase

  import Phoenix.LiveViewTest
  import RbagElections.abgabenFixtures()

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_abgabe(_) do
    abgabe = abgabe_fixture()
    %{abgabe: abgabe}
  end

  describe "Index" do
    setup [:create_abgabe]

    test "lists all abgaben", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/abgaben")

      assert html =~ "Listing abgaben"
    end

    test "saves new abgabe", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/abgaben")

      assert index_live |> element("a", "New abgabe") |> render_click() =~
               "New abgabe"

      assert_patch(index_live, ~p"/abgaben/new")

      assert index_live
             |> form("#abgabe-form", abgabe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#abgabe-form", abgabe: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/abgaben")

      html = render(index_live)
      assert html =~ "abgabe created successfully"
    end

    test "updates abgabe in listing", %{conn: conn, abgabe: abgabe} do
      {:ok, index_live, _html} = live(conn, ~p"/abgaben")

      assert index_live |> element("#abgaben-#{abgabe.id} a", "Edit") |> render_click() =~
               "Edit abgabe"

      assert_patch(index_live, ~p"/abgaben/#{abgabe}/edit")

      assert index_live
             |> form("#abgabe-form", abgabe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#abgabe-form", abgabe: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/abgaben")

      html = render(index_live)
      assert html =~ "abgabe updated successfully"
    end

    test "deletes abgabe in listing", %{conn: conn, abgabe: abgabe} do
      {:ok, index_live, _html} = live(conn, ~p"/abgaben")

      assert index_live |> element("#abgaben-#{abgabe.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#abgaben-#{abgabe.id}")
    end
  end

  describe "Show" do
    setup [:create_abgabe]

    test "displays abgabe", %{conn: conn, abgabe: abgabe} do
      {:ok, _show_live, html} = live(conn, ~p"/abgaben/#{abgabe}")

      assert html =~ "Show abgabe"
    end

    test "updates abgabe within modal", %{conn: conn, abgabe: abgabe} do
      {:ok, show_live, _html} = live(conn, ~p"/abgaben/#{abgabe}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit abgabe"

      assert_patch(show_live, ~p"/abgaben/#{abgabe}/show/edit")

      assert show_live
             |> form("#abgabe-form", abgabe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#abgabe-form", abgabe: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/abgaben/#{abgabe}")

      html = render(show_live)
      assert html =~ "abgabe updated successfully"
    end
  end
end
