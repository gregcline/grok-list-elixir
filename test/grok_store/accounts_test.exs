defmodule GrokStore.AccountsTest do
  use GrokStore.DataCase

  alias GrokStore.Accounts
  alias GrokStore.Repo

  describe "users" do
    alias GrokStore.Accounts.User

    @valid_attrs %{
      email: "some@email.com",
      name: "some name",
      passhash: "some passhash",
      password: "some password"
    }
    @update_attrs %{
      email: "some_updated@email.com",
      name: "some updated name",
      passhash: "some updated passhash",
      password: "some updated password"
    }
    @invalid_attrs %{email: nil, name: nil, passhash: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user =
        user_fixture()
        |> Map.put(:password, nil)

      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user =
        user_fixture()
        |> Map.put(:password, nil)

      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some_updated@email.com"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user =
        user_fixture()
        |> Map.put(:password, nil)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/2 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "add_list/2 associates a list with a user" do
      user = user_fixture()
      list = GrokStore.GroceryHelper.list_fixture()
      assert {:ok, %User{} = user} = Accounts.add_list(user, list)
      assert list == hd(user.lists)

      list2 = GrokStore.GroceryHelper.list_fixture()
      assert {:ok, %User{} = user} = Accounts.add_list(user, list2)
      assert [list2, list] == user.lists
    end

    test "get_user_list/2 fetches a list if the user is a member" do
      user = user_fixture()
      list = GrokStore.GroceryHelper.list_fixture()
      assert nil == Accounts.get_user_list(user, list.id)
      Accounts.add_list(user, list)
      list = Repo.preload(list, [:users])
      assert list == Accounts.get_user_list(user, list.id)
    end
  end
end
