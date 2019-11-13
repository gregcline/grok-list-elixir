defmodule GrokStoreWeb.Absinthe.Mutations.ListTest do
  use GrokStoreWeb.ConnCase
  alias GrokStore.Accounts
  alias GrokStoreWeb.Schema
  alias GrokStore.Groceries.List, as: GList
  alias GrokStore.Groceries

  setup do
    {:ok, user} =
      Accounts.create_user(%{
        name: "Treebeard",
        email: "treebeard@fangorn.com",
        password: "the ent wives"
      })

    {:ok, list} =
      Groceries.create_list(%{
        title: "Water"
      })

    {:ok, user} = Accounts.add_list(user, list)

    {:ok, user: user, list: list}
  end

  describe "create" do
    test "returns list info on creation", %{user: user} do
      query = """
      mutation ListCreate {
        createList(title: "Water") {
          title
          items {
            text
          }
          users {
            id
            name
            email
          }
        }
      }
      """

      {:ok, %{data: %{"createList" => list}}} =
        Absinthe.run(query, Schema, context: %{user: user})

      assert list["title"] == "Water"

      assert [%{"id" => to_string(user.id), "name" => user.name, "email" => user.email}] ==
               list["users"]

      assert list["items"] == []
    end

    test "returns an error if no user is signed in" do
      query = """
      mutation ListCreate {
        createList(title: "Water") {
          title
        }
      }
      """

      {:ok, %{errors: [error | []]}} = Absinthe.run(query, Schema)

      assert "You must be signed in to create a list" == error[:message]
    end
  end

  describe "addItem" do
    test "adds an item to a list", %{list: list, user: user} do
      query = """
      mutation AddItem {
        addItem(listId: #{list.id}, text: "draught", price: 12.99, quantity: 2) {
          text
          price
          quantity
          checked
          listId
        }
      }
      """

      {:ok, %{data: %{"addItem" => item}}} = Absinthe.run(query, Schema, context: %{user: user})

      assert item == %{
               "text" => "draught",
               "price" => 12.99,
               "quantity" => 2.0,
               "checked" => false,
               "listId" => to_string(list.id)
             }
    end

    test "only signed in users can add items to lists", %{list: list} do
      query = """
      mutation AddItem {
        addItem(listId: #{list.id}, text: "Salmon") {
          text
        }
      }
      """

      {:ok, %{errors: [error | []]}} = Absinthe.run(query, Schema)

      assert error[:message] == "You must be signed in to add an item to a list"
    end

    test "signed in users can only add items to lists they are members of", %{list: list} do
      query = """
      mutation AddItem {
        addItem(listId: #{list.id}, text: "Salmon") {
          text
        }
      }
      """

      {:ok, user_2} =
        Accounts.create_user(%{
          name: "Gollum",
          email: "smeagol@misty-mountains.net",
          password: "the precious"
        })

      {:ok, %{errors: [error | []]}} = Absinthe.run(query, Schema, context: %{user: user_2})

      assert error[:message] == "You must be a member of the list to add to it"
    end
  end

  describe "checkItem" do
    test "should toggle the checked state of an item", %{user: user, list: list} do
      item_attrs = %{
        text: "Draught",
        price: 2.99,
        quantity: 1.0
      }

      {:ok, item} = Groceries.add_item_to_list(list, item_attrs)

      query = """
      mutation CheckItem {
        checkItem(id: #{item.id}) {
          text
          checked
        }
      }
      """

      {:ok, %{data: %{"checkItem" => checked_item}}} =
        Absinthe.run(query, Schema, context: %{user: user})

      assert checked_item["text"] == item.text
      assert checked_item["checked"] == !item.checked

      {:ok, %{data: %{"checkItem" => checked_item}}} =
        Absinthe.run(query, Schema, context: %{user: user})

      assert checked_item["text"] == item.text
      assert checked_item["checked"] == item.checked
    end

    test "can only check items if signed in", %{list: list} do
      item_attrs = %{
        text: "Draught",
        price: 2.99,
        quantity: 1.0
      }

      {:ok, item} = Groceries.add_item_to_list(list, item_attrs)

      query = """
      mutation CheckItem {
        checkItem(id: #{item.id}) {
          text
          checked
        }
      }
      """

      {:ok, %{errors: [error | []]}} = Absinthe.run(query, Schema)

      assert error[:message] == "You must be signed in to check an item"
    end

    test "can only check items if a member of the list", %{list: list} do
      item_attrs = %{
        text: "Draught",
        price: 2.99,
        quantity: 1.0
      }

      {:ok, item} = Groceries.add_item_to_list(list, item_attrs)

      query = """
      mutation CheckItem {
        checkItem(id: #{item.id}) {
          text
          checked
        }
      }
      """

      {:ok, user_2} =
        Accounts.create_user(%{
          name: "Gollum",
          email: "smeagol@misty-mountains.net",
          password: "the precious"
        })

      {:ok, %{errors: [error | []]}} = Absinthe.run(query, Schema, context: %{user: user_2})

      assert error[:message] == "You must be a member of a list to check an item on it"
    end
  end
end
