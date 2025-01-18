defmodule RbagElections.WahlleitungTest do
  use RbagElections.DataCase

  alias RbagElections.Wahlleitung

  describe "durchgaenge" do
    alias RbagElections.Wahlleitung.abstimmung()

    import RbagElections.WahlleitungFixtures

    @invalid_attrs %{status: nil}

    test "list_durchgaenge/0 returns all durchgaenge" do
      abstimmung = abstimmung_fixture()
      assert Wahlleitung.list_durchgaenge() == [abstimmung]
    end

    test "get_abstimmung!/1 returns the abstimmung with given id" do
      abstimmung = abstimmung_fixture()
      assert Wahlleitung.get_abstimmung!(abstimmung.id) == abstimmung
    end

    test "create_abstimmung/1 with valid data creates a abstimmung" do
      valid_attrs = %{status: "some status"}

      assert {:ok, %abstimmung{} = abstimmung} = Wahlleitung.create_abstimmung(valid_attrs)
      assert abstimmung.status == "some status"
    end

    test "create_abstimmung/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wahlleitung.create_abstimmung(@invalid_attrs)
    end

    test "update_abstimmung/2 with valid data updates the abstimmung" do
      abstimmung = abstimmung_fixture()
      update_attrs = %{status: "some updated status"}

      assert {:ok, %abstimmung{} = abstimmung} =
               Wahlleitung.update_abstimmung(abstimmung, update_attrs)

      assert abstimmung.status == "some updated status"
    end

    test "update_abstimmung/2 with invalid data returns error changeset" do
      abstimmung = abstimmung_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Wahlleitung.update_abstimmung(abstimmung, @invalid_attrs)

      assert abstimmung == Wahlleitung.get_abstimmung!(abstimmung.id)
    end

    test "delete_abstimmung/1 deletes the abstimmung" do
      abstimmung = abstimmung_fixture()
      assert {:ok, %abstimmung{}} = Wahlleitung.delete_abstimmung(abstimmung)
      assert_raise Ecto.NoResultsError, fn -> Wahlleitung.get_abstimmung!(abstimmung.id) end
    end

    test "change_abstimmung/1 returns a abstimmung changeset" do
      abstimmung = abstimmung_fixture()
      assert %Ecto.Changeset{} = Wahlleitung.change_abstimmung(abstimmung)
    end
  end
end
