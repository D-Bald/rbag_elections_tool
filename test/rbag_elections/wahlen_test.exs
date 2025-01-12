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

  describe "positionen" do
    alias RbagElections.Wahlen.Position

    import RbagElections.WahlenFixtures

    @invalid_attrs %{index: nil, beschreibung: nil}

    test "list_positionen/0 returns all positionen" do
      position = position_fixture()
      assert Wahlen.list_positionen() == [position]
    end

    test "get_position!/1 returns the position with given id" do
      position = position_fixture()
      assert Wahlen.get_position!(position.id) == position
    end

    test "create_position/1 with valid data creates a position" do
      valid_attrs = %{index: 42, beschreibung: "some beschreibung"}

      assert {:ok, %Position{} = position} = Wahlen.create_position(valid_attrs)
      assert position.index == 42
      assert position.beschreibung == "some beschreibung"
    end

    test "create_position/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wahlen.create_position(@invalid_attrs)
    end

    test "update_position/2 with valid data updates the position" do
      position = position_fixture()
      update_attrs = %{index: 43, beschreibung: "some updated beschreibung"}

      assert {:ok, %Position{} = position} = Wahlen.update_position(position, update_attrs)
      assert position.index == 43
      assert position.beschreibung == "some updated beschreibung"
    end

    test "update_position/2 with invalid data returns error changeset" do
      position = position_fixture()
      assert {:error, %Ecto.Changeset{}} = Wahlen.update_position(position, @invalid_attrs)
      assert position == Wahlen.get_position!(position.id)
    end

    test "delete_position/1 deletes the position" do
      position = position_fixture()
      assert {:ok, %Position{}} = Wahlen.delete_position(position)
      assert_raise Ecto.NoResultsError, fn -> Wahlen.get_position!(position.id) end
    end

    test "change_position/1 returns a position changeset" do
      position = position_fixture()
      assert %Ecto.Changeset{} = Wahlen.change_position(position)
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
