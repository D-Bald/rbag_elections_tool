defmodule RbagElectionsWeb.StimmeLiveTest do
  use RbagElectionsWeb.ConnCase

  import Phoenix.LiveViewTest
  import RbagElections.AbstimmungenFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_stimme(_) do
    stimme = stimme_fixture()
    %{stimme: stimme}
  end

  describe "Index" do
    setup [:create_stimme]

    test "lists all stimmen", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/stimmen")

      assert html =~ "Listing Stimmen"
    end

    test "saves new stimme", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/stimmen")

      assert index_live |> element("a", "New Stimme") |> render_click() =~
               "New Stimme"

      assert_patch(index_live, ~p"/stimmen/new")

      assert index_live
             |> form("#stimme-form", stimme: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#stimme-form", stimme: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/stimmen")

      html = render(index_live)
      assert html =~ "Stimme created successfully"
    end

    test "updates stimme in listing", %{conn: conn, stimme: stimme} do
      {:ok, index_live, _html} = live(conn, ~p"/stimmen")

      assert index_live |> element("#stimmen-#{stimme.id} a", "Edit") |> render_click() =~
               "Edit Stimme"

      assert_patch(index_live, ~p"/stimmen/#{stimme}/edit")

      assert index_live
             |> form("#stimme-form", stimme: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#stimme-form", stimme: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/stimmen")

      html = render(index_live)
      assert html =~ "Stimme updated successfully"
    end

    test "deletes stimme in listing", %{conn: conn, stimme: stimme} do
      {:ok, index_live, _html} = live(conn, ~p"/stimmen")

      assert index_live |> element("#stimmen-#{stimme.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#stimmen-#{stimme.id}")
    end
  end

  describe "Show" do
    setup [:create_stimme]

    test "displays stimme", %{conn: conn, stimme: stimme} do
      {:ok, _show_live, html} = live(conn, ~p"/stimmen/#{stimme}")

      assert html =~ "Show Stimme"
    end

    test "updates stimme within modal", %{conn: conn, stimme: stimme} do
      {:ok, show_live, _html} = live(conn, ~p"/stimmen/#{stimme}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Stimme"

      assert_patch(show_live, ~p"/stimmen/#{stimme}/show/edit")

      assert show_live
             |> form("#stimme-form", stimme: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#stimme-form", stimme: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/stimmen/#{stimme}")

      html = render(show_live)
      assert html =~ "Stimme updated successfully"
    end
  end
end
