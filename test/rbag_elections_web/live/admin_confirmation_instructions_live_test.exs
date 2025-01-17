defmodule RbagElectionsWeb.AdminConfirmationInstructionsLiveTest do
  use RbagElectionsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import RbagElections.ManagementFixtures

  alias RbagElections.Management
  alias RbagElections.Repo

  setup do
    %{admin: admin_fixture()}
  end

  describe "Resend confirmation" do
    test "renders the resend confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/admins/confirm")
      assert html =~ "Resend confirmation instructions"
    end

    test "sends a new confirmation token", %{conn: conn, admin: admin} do
      {:ok, lv, _html} = live(conn, ~p"/admins/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", admin: %{email: admin.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(Management.AdminToken, admin_id: admin.id).context == "confirm"
    end

    test "does not send confirmation token if admin is confirmed", %{conn: conn, admin: admin} do
      Repo.update!(Management.Admin.confirm_changeset(admin))

      {:ok, lv, _html} = live(conn, ~p"/admins/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", admin: %{email: admin.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      refute Repo.get_by(Management.AdminToken, admin_id: admin.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/admins/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", admin: %{email: "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.all(Management.AdminToken) == []
    end
  end
end
