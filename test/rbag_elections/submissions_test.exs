defmodule RbagElections.abgabenTest() do
  use RbagElections.DataCase

  alias RbagElections.abgaben()

  describe "abgaben" do
    alias RbagElections.abgaben().abgabe

    import RbagElections.abgabenFixtures()

    @invalid_attrs %{}

    test "list_abgaben/0 returns all abgaben" do
      abgabe = abgabe_fixture()
      assert Abstimmungen.list_abgaben() == [abgabe]
    end

    test "get_abgabe!/1 returns the abgabe with given id" do
      abgabe = abgabe_fixture()
      assert Abstimmungen.get_abgabe!(abgabe.id) == abgabe
    end

    test "create_abgabe/1 with valid data creates a abgabe" do
      valid_attrs = %{}

      assert {:ok, %abgabe{} = abgabe} = Abstimmungen.create_abgabe(valid_attrs)
    end

    test "create_abgabe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Abstimmungen.create_abgabe(@invalid_attrs)
    end

    test "update_abgabe/2 with valid data updates the abgabe" do
      abgabe = abgabe_fixture()
      update_attrs = %{}

      assert {:ok, %abgabe{} = abgabe} =
               Abstimmungen.update_abgabe(abgabe, update_attrs)
    end

    test "update_abgabe/2 with invalid data returns error changeset" do
      abgabe = abgabe_fixture()
      assert {:error, %Ecto.Changeset{}} = Abstimmungen.update_abgabe(abgabe, @invalid_attrs)
      assert abgabe == Abstimmungen.get_abgabe!(abgabe.id)
    end

    test "delete_abgabe/1 deletes the abgabe" do
      abgabe = abgabe_fixture()
      assert {:ok, %abgabe{}} = Abstimmungen.delete_abgabe(abgabe)
      assert_raise Ecto.NoResultsError, fn -> Abstimmungen.get_abgabe!(abgabe.id) end
    end

    test "change_abgabe/1 returns a abgabe changeset" do
      abgabe = abgabe_fixture()
      assert %Ecto.Changeset{} = Abstimmungen.change_abgabe(abgabe)
    end
  end
end
