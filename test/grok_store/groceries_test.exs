defmodule GrokStore.GroceriesTest do
  use GrokStore.DataCase

  alias GrokStore.Groceries

  describe "lists" do
    alias GrokStore.Groceries.List

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def list_fixture(attrs \\ %{}) do
      {:ok, list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Groceries.create_list()

      list
    end

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Groceries.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Groceries.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      assert {:ok, %List{} = list} = Groceries.create_list(@valid_attrs)
      assert list.title == "some title"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groceries.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      assert {:ok, %List{} = list} = Groceries.update_list(list, @update_attrs)
      assert list.title == "some updated title"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Groceries.update_list(list, @invalid_attrs)
      assert list == Groceries.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Groceries.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Groceries.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Groceries.change_list(list)
    end
  end

  describe "list_items" do
    alias GrokStore.Groceries.ListItem

    @valid_attrs %{
      checked: true,
      location: "some location",
      price: 120.5,
      quantity: 42,
      text: "some text"
    }
    @update_attrs %{
      checked: false,
      location: "some updated location",
      price: 456.7,
      quantity: 43,
      text: "some updated text"
    }
    @invalid_attrs %{checked: nil, location: nil, price: nil, quantity: nil, text: nil}

    def list_item_fixture(attrs \\ %{}) do
      {:ok, list_item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Groceries.create_list_item()

      list_item
    end

    test "list_list_items/0 returns all list_items" do
      list_item = list_item_fixture()
      assert Groceries.list_list_items() == [list_item]
    end

    test "get_list_item!/1 returns the list_item with given id" do
      list_item = list_item_fixture()
      assert Groceries.get_list_item!(list_item.id) == list_item
    end

    test "create_list_item/1 with valid data creates a list_item" do
      assert {:ok, %ListItem{} = list_item} = Groceries.create_list_item(@valid_attrs)
      assert list_item.checked == true
      assert list_item.location == "some location"
      assert list_item.price == 120.5
      assert list_item.quantity == 42
      assert list_item.text == "some text"
    end

    test "create_list_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groceries.create_list_item(@invalid_attrs)
    end

    test "update_list_item/2 with valid data updates the list_item" do
      list_item = list_item_fixture()
      assert {:ok, %ListItem{} = list_item} = Groceries.update_list_item(list_item, @update_attrs)
      assert list_item.checked == false
      assert list_item.location == "some updated location"
      assert list_item.price == 456.7
      assert list_item.quantity == 43
      assert list_item.text == "some updated text"
    end

    test "update_list_item/2 with invalid data returns error changeset" do
      list_item = list_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Groceries.update_list_item(list_item, @invalid_attrs)
      assert list_item == Groceries.get_list_item!(list_item.id)
    end

    test "delete_list_item/1 deletes the list_item" do
      list_item = list_item_fixture()
      assert {:ok, %ListItem{}} = Groceries.delete_list_item(list_item)
      assert_raise Ecto.NoResultsError, fn -> Groceries.get_list_item!(list_item.id) end
    end

    test "change_list_item/1 returns a list_item changeset" do
      list_item = list_item_fixture()
      assert %Ecto.Changeset{} = Groceries.change_list_item(list_item)
    end

    test "add_item_to_list/2 adds an item to the list" do
      {:ok, list} = Groceries.create_list(%{title: "A title"})

      item = %{
        text: "salmon",
        price: 19.99,
        quantity: 1.0
      }

      Groceries.add_item_to_list(list, item)

      [list_item | []] = Groceries.list_items_in_list(list)

      assert list_item.text == item[:text]
      assert list_item.price == item[:price]
      assert list_item.quantity == item[:quantity]
      assert list_item.checked == false
    end
  end
end
