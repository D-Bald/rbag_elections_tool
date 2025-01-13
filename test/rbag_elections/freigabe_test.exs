defmodule RbagElections.FreigabeTest do
  use RbagElections.DataCase

  alias RbagElections.Freigabe

  describe "tokens" do
    alias RbagElections.Freigabe.Token

    import RbagElections.FreigabeFixtures

    @invalid_attrs %{uuid: nil, besitzer: nil, freigegeben: nil}

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Freigabe.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Freigabe.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      valid_attrs = %{uuid: "7488a646-e31f-11e4-aace-600308960662", besitzer: "some besitzer", freigegeben: true}

      assert {:ok, %Token{} = token} = Freigabe.create_token(valid_attrs)
      assert token.uuid == "7488a646-e31f-11e4-aace-600308960662"
      assert token.besitzer == "some besitzer"
      assert token.freigegeben == true
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Freigabe.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      update_attrs = %{uuid: "7488a646-e31f-11e4-aace-600308960668", besitzer: "some updated besitzer", freigegeben: false}

      assert {:ok, %Token{} = token} = Freigabe.update_token(token, update_attrs)
      assert token.uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert token.besitzer == "some updated besitzer"
      assert token.freigegeben == false
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Freigabe.update_token(token, @invalid_attrs)
      assert token == Freigabe.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Freigabe.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Freigabe.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Freigabe.change_token(token)
    end
  end
end
