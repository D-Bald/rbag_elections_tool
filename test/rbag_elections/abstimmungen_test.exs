defmodule RbagElections.AbstimmungenTest do
  use RbagElections.DataCase

  alias RbagElections.Abstimmungen

  describe "abstimmungen" do
    alias RbagElections.Abstimmungen.Abstimmung

    import RbagElections.AbstimmungenFixtures

    @invalid_attrs %{}

    test "list_abstimmungen/0 returns all abstimmungen" do
      abstimmung = abstimmung_fixture()
      assert Abstimmungen.list_abstimmungen() == [abstimmung]
    end

    test "get_abstimmung!/1 returns the abstimmung with given id" do
      abstimmung = abstimmung_fixture()
      assert Abstimmungen.get_abstimmung!(abstimmung.id) == abstimmung
    end

    test "create_abstimmung/1 with valid data creates a abstimmung" do
      valid_attrs = %{}

      assert {:ok, %Abstimmung{} = abstimmung} = Abstimmungen.create_abstimmung(valid_attrs)
    end

    test "create_abstimmung/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Abstimmungen.create_abstimmung(@invalid_attrs)
    end

    test "update_abstimmung/2 with valid data updates the abstimmung" do
      abstimmung = abstimmung_fixture()
      update_attrs = %{}

      assert {:ok, %Abstimmung{} = abstimmung} = Abstimmungen.update_abstimmung(abstimmung, update_attrs)
    end

    test "update_abstimmung/2 with invalid data returns error changeset" do
      abstimmung = abstimmung_fixture()
      assert {:error, %Ecto.Changeset{}} = Abstimmungen.update_abstimmung(abstimmung, @invalid_attrs)
      assert abstimmung == Abstimmungen.get_abstimmung!(abstimmung.id)
    end

    test "delete_abstimmung/1 deletes the abstimmung" do
      abstimmung = abstimmung_fixture()
      assert {:ok, %Abstimmung{}} = Abstimmungen.delete_abstimmung(abstimmung)
      assert_raise Ecto.NoResultsError, fn -> Abstimmungen.get_abstimmung!(abstimmung.id) end
    end

    test "change_abstimmung/1 returns a abstimmung changeset" do
      abstimmung = abstimmung_fixture()
      assert %Ecto.Changeset{} = Abstimmungen.change_abstimmung(abstimmung)
    end
  end

  describe "stimmen" do
    alias RbagElections.Abstimmungen.Stimme

    import RbagElections.AbstimmungenFixtures

    @invalid_attrs %{}

    test "list_stimmen/0 returns all stimmen" do
      stimme = stimme_fixture()
      assert Abstimmungen.list_stimmen() == [stimme]
    end

    test "get_stimme!/1 returns the stimme with given id" do
      stimme = stimme_fixture()
      assert Abstimmungen.get_stimme!(stimme.id) == stimme
    end

    test "create_stimme/1 with valid data creates a stimme" do
      valid_attrs = %{}

      assert {:ok, %Stimme{} = stimme} = Abstimmungen.create_stimme(valid_attrs)
    end

    test "create_stimme/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Abstimmungen.create_stimme(@invalid_attrs)
    end

    test "update_stimme/2 with valid data updates the stimme" do
      stimme = stimme_fixture()
      update_attrs = %{}

      assert {:ok, %Stimme{} = stimme} = Abstimmungen.update_stimme(stimme, update_attrs)
    end

    test "update_stimme/2 with invalid data returns error changeset" do
      stimme = stimme_fixture()
      assert {:error, %Ecto.Changeset{}} = Abstimmungen.update_stimme(stimme, @invalid_attrs)
      assert stimme == Abstimmungen.get_stimme!(stimme.id)
    end

    test "delete_stimme/1 deletes the stimme" do
      stimme = stimme_fixture()
      assert {:ok, %Stimme{}} = Abstimmungen.delete_stimme(stimme)
      assert_raise Ecto.NoResultsError, fn -> Abstimmungen.get_stimme!(stimme.id) end
    end

    test "change_stimme/1 returns a stimme changeset" do
      stimme = stimme_fixture()
      assert %Ecto.Changeset{} = Abstimmungen.change_stimme(stimme)
    end
  end
end
