defmodule RbagElections.WahlleitungTest do
  use RbagElections.DataCase

  alias RbagElections.Wahlleitung

  describe "durchgaenge" do
    alias RbagElections.Wahlleitung.Durchgang

    import RbagElections.WahlleitungFixtures

    @invalid_attrs %{status: nil}

    test "list_durchgaenge/0 returns all durchgaenge" do
      durchgang = durchgang_fixture()
      assert Wahlleitung.list_durchgaenge() == [durchgang]
    end

    test "get_durchgang!/1 returns the durchgang with given id" do
      durchgang = durchgang_fixture()
      assert Wahlleitung.get_durchgang!(durchgang.id) == durchgang
    end

    test "create_durchgang/1 with valid data creates a durchgang" do
      valid_attrs = %{status: "some status"}

      assert {:ok, %Durchgang{} = durchgang} = Wahlleitung.create_durchgang(valid_attrs)
      assert durchgang.status == "some status"
    end

    test "create_durchgang/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wahlleitung.create_durchgang(@invalid_attrs)
    end

    test "update_durchgang/2 with valid data updates the durchgang" do
      durchgang = durchgang_fixture()
      update_attrs = %{status: "some updated status"}

      assert {:ok, %Durchgang{} = durchgang} = Wahlleitung.update_durchgang(durchgang, update_attrs)
      assert durchgang.status == "some updated status"
    end

    test "update_durchgang/2 with invalid data returns error changeset" do
      durchgang = durchgang_fixture()
      assert {:error, %Ecto.Changeset{}} = Wahlleitung.update_durchgang(durchgang, @invalid_attrs)
      assert durchgang == Wahlleitung.get_durchgang!(durchgang.id)
    end

    test "delete_durchgang/1 deletes the durchgang" do
      durchgang = durchgang_fixture()
      assert {:ok, %Durchgang{}} = Wahlleitung.delete_durchgang(durchgang)
      assert_raise Ecto.NoResultsError, fn -> Wahlleitung.get_durchgang!(durchgang.id) end
    end

    test "change_durchgang/1 returns a durchgang changeset" do
      durchgang = durchgang_fixture()
      assert %Ecto.Changeset{} = Wahlleitung.change_durchgang(durchgang)
    end
  end
end
