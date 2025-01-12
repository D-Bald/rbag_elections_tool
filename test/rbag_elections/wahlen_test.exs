defmodule RbagElections.WahlenTest do
  use RbagElections.DataCase

  alias RbagElections.Wahlen

  describe "wahlen" do
    alias RbagElections.Wahlen.Wahl

    import RbagElections.WahlenFixtures

    @invalid_attrs %{beschreibung: nil}

    test "list_wahlen/0 returns all wahlen" do
      wahl = wahl_fixture()
      assert Wahlen.list_wahlen() == [wahl]
    end

    test "get_wahl!/1 returns the wahl with given id" do
      wahl = wahl_fixture()
      assert Wahlen.get_wahl!(wahl.id) == wahl
    end

    test "create_wahl/1 with valid data creates a wahl" do
      valid_attrs = %{beschreibung: "some beschreibung"}

      assert {:ok, %Wahl{} = wahl} = Wahlen.create_wahl(valid_attrs)
      assert wahl.beschreibung == "some beschreibung"
    end

    test "create_wahl/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wahlen.create_wahl(@invalid_attrs)
    end

    test "update_wahl/2 with valid data updates the wahl" do
      wahl = wahl_fixture()
      update_attrs = %{beschreibung: "some updated beschreibung"}

      assert {:ok, %Wahl{} = wahl} = Wahlen.update_wahl(wahl, update_attrs)
      assert wahl.beschreibung == "some updated beschreibung"
    end

    test "update_wahl/2 with invalid data returns error changeset" do
      wahl = wahl_fixture()
      assert {:error, %Ecto.Changeset{}} = Wahlen.update_wahl(wahl, @invalid_attrs)
      assert wahl == Wahlen.get_wahl!(wahl.id)
    end

    test "delete_wahl/1 deletes the wahl" do
      wahl = wahl_fixture()
      assert {:ok, %Wahl{}} = Wahlen.delete_wahl(wahl)
      assert_raise Ecto.NoResultsError, fn -> Wahlen.get_wahl!(wahl.id) end
    end

    test "change_wahl/1 returns a wahl changeset" do
      wahl = wahl_fixture()
      assert %Ecto.Changeset{} = Wahlen.change_wahl(wahl)
    end
  end

  describe "fragen" do
    alias RbagElections.Wahlen.Frage

    import RbagElections.WahlenFixtures

    @invalid_attrs %{index: nil, beschreibung: nil}

    test "list_fragen/0 returns all fragen" do
      frage = frage_fixture()
      assert Wahlen.list_fragen() == [frage]
    end

    test "get_frage!/1 returns the frage with given id" do
      frage = frage_fixture()
      assert Wahlen.get_frage!(frage.id) == frage
    end

    test "create_frage/1 with valid data creates a frage" do
      valid_attrs = %{index: 42, beschreibung: "some beschreibung"}

      assert {:ok, %Frage{} = frage} = Wahlen.create_frage(valid_attrs)
      assert frage.index == 42
      assert frage.beschreibung == "some beschreibung"
    end

    test "create_frage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wahlen.create_frage(@invalid_attrs)
    end

    test "update_frage/2 with valid data updates the frage" do
      frage = frage_fixture()
      update_attrs = %{index: 43, beschreibung: "some updated beschreibung"}

      assert {:ok, %Frage{} = frage} = Wahlen.update_frage(frage, update_attrs)
      assert frage.index == 43
      assert frage.beschreibung == "some updated beschreibung"
    end

    test "update_frage/2 with invalid data returns error changeset" do
      frage = frage_fixture()
      assert {:error, %Ecto.Changeset{}} = Wahlen.update_frage(frage, @invalid_attrs)
      assert frage == Wahlen.get_frage!(frage.id)
    end

    test "delete_frage/1 deletes the frage" do
      frage = frage_fixture()
      assert {:ok, %Frage{}} = Wahlen.delete_frage(frage)
      assert_raise Ecto.NoResultsError, fn -> Wahlen.get_frage!(frage.id) end
    end

    test "change_frage/1 returns a frage changeset" do
      frage = frage_fixture()
      assert %Ecto.Changeset{} = Wahlen.change_frage(frage)
    end
  end

  describe "optionen" do
    alias RbagElections.Wahlen.Option

    import RbagElections.WahlenFixtures

    @invalid_attrs %{wert: nil}

    test "list_optionen/0 returns all optionen" do
      option = option_fixture()
      assert Wahlen.list_optionen() == [option]
    end

    test "get_option!/1 returns the option with given id" do
      option = option_fixture()
      assert Wahlen.get_option!(option.id) == option
    end

    test "create_option/1 with valid data creates a option" do
      valid_attrs = %{wert: "some wert"}

      assert {:ok, %Option{} = option} = Wahlen.create_option(valid_attrs)
      assert option.wert == "some wert"
    end

    test "create_option/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wahlen.create_option(@invalid_attrs)
    end

    test "update_option/2 with valid data updates the option" do
      option = option_fixture()
      update_attrs = %{wert: "some updated wert"}

      assert {:ok, %Option{} = option} = Wahlen.update_option(option, update_attrs)
      assert option.wert == "some updated wert"
    end

    test "update_option/2 with invalid data returns error changeset" do
      option = option_fixture()
      assert {:error, %Ecto.Changeset{}} = Wahlen.update_option(option, @invalid_attrs)
      assert option == Wahlen.get_option!(option.id)
    end

    test "delete_option/1 deletes the option" do
      option = option_fixture()
      assert {:ok, %Option{}} = Wahlen.delete_option(option)
      assert_raise Ecto.NoResultsError, fn -> Wahlen.get_option!(option.id) end
    end

    test "change_option/1 returns a option changeset" do
      option = option_fixture()
      assert %Ecto.Changeset{} = Wahlen.change_option(option)
    end
  end
end
