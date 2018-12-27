defmodule Momento.AccountsTest do
  use Momento.DataCase

  alias Momento.Accounts

  describe "users" do
    alias Momento.Accounts.User

    @valid_attrs %{email: "some email", password: "some password_hash", username: "some username"}
    @update_attrs %{
      email: "some updated email",
      password: "some updated password_hash",
      username: "some updated username"
    }
    @invalid_attrs %{email: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      users =  Accounts.list_users()
      assert is_list(users)
      assert length(users) > 0
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      expected_user = Accounts.get_user(user.id)
      assert user.id == expected_user.id
      assert user.email == expected_user.email
      assert user.username == expected_user.username
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert Bcrypt.verify_pass("some password_hash", user.password_hash)
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert Bcrypt.verify_pass("some updated password_hash", user.password_hash)
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      expected_user = Accounts.get_user(user.id)
      assert user.username == expected_user.username
      assert user.id == expected_user.id
      assert user.email == expected_user.email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert is_nil(Accounts.get_user(user.id))
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
