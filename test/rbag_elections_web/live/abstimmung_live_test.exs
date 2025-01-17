defmodule RbagElectionsWeb.AbstimmungLiveTest do
  use RbagElectionsWeb.ConnCase

  import Phoenix.LiveViewTest
  import RbagElections.AbstimmungenFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_abstimmung(_) do
    abstimmung = abstimmung_fixture()
    %{abstimmung: abstimmung}
  end

  describe "Index" do
    setup [:create_abstimmung]

    test "lists all abstimmungen", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/abstimmungen")

      assert html =~ "Listing Abstimmungen"
    end

    test "saves new abstimmung", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/abstimmungen")

      assert index_live |> element("a", "New Abstimmung") |> render_click() =~
               "New Abstimmung"

      assert_patch(index_live, ~p"/abstimmungen/new")

      assert index_live
             |> form("#abstimmung-form", abstimmung: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#abstimmung-form", abstimmung: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/abstimmungen")

      html = render(index_live)
      assert html =~ "Abstimmung created successfully"
    end

    test "updates abstimmung in listing", %{conn: conn, abstimmung: abstimmung} do
      {:ok, index_live, _html} = live(conn, ~p"/abstimmungen")

      assert index_live |> element("#abstimmungen-#{abstimmung.id} a", "Edit") |> render_click() =~
               "Edit Abstimmung"

      assert_patch(index_live, ~p"/abstimmungen/#{abstimmung}/edit")

      assert index_live
             |> form("#abstimmung-form", abstimmung: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#abstimmung-form", abstimmung: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/abstimmungen")

      html = render(index_live)
      assert html =~ "Abstimmung updated successfully"
    end

    test "deletes abstimmung in listing", %{conn: conn, abstimmung: abstimmung} do
      {:ok, index_live, _html} = live(conn, ~p"/abstimmungen")

      assert index_live |> element("#abstimmungen-#{abstimmung.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#abstimmungen-#{abstimmung.id}")
    end
  end

  describe "Show" do
    setup [:create_abstimmung]

    test "displays abstimmung", %{conn: conn, abstimmung: abstimmung} do
      {:ok, _show_live, html} = live(conn, ~p"/abstimmungen/#{abstimmung}")

      assert html =~ "Show Abstimmung"
    end

    test "updates abstimmung within modal", %{conn: conn, abstimmung: abstimmung} do
      {:ok, show_live, _html} = live(conn, ~p"/abstimmungen/#{abstimmung}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Abstimmung"

      assert_patch(show_live, ~p"/abstimmungen/#{abstimmung}/show/edit")

      assert show_live
             |> form("#abstimmung-form", abstimmung: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#abstimmung-form", abstimmung: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/abstimmungen/#{abstimmung}")

      html = render(show_live)
      assert html =~ "Abstimmung updated successfully"
    end
  end
end
