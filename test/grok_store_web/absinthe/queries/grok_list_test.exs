defmodule GrokStoreWeb.Absinthe.Queries.ListTest do
  use GrokStoreWeb.ConnCase
  alias GrokStoreWeb.Schema
  alias GrokStore.Groceries
  alias GrokStore.Accounts
  alias GrokStore.Accounts.User

  setup do
    {:ok, user} =
      Accounts.create_user(%{
        name: "Glorfindel",
        email: "elf-lord@rivendell.io",
        password: "mellon"
      })

    {:ok, user: %User{user | password: nil}}
  end

  test "no lists", %{user: user} do
    query = """
    {
      grokLists {
        id
        title
      }
    }
    """

    {:ok, %{data: %{"grokLists" => lists}}} = Absinthe.run(query, Schema)
    assert lists == []
    context = %{user: user}
    {:ok, %{data: %{"grokLists" => lists}}} = Absinthe.run(query, Schema, context: context)
    assert lists == []
  end

  test "getting a list", %{user: user} do
    {:ok, list} = Groceries.create_list(%{title: "A title"})
    {:ok, list2} = Groceries.create_list(%{title: "Another title"})

    {:ok, user} = Accounts.add_list(user, list)

    query = """
    {
      grokLists {
        id
        title
      }
    }
    """

    context = %{user: user}

    {:ok, %{data: %{"grokLists" => lists}}} = Absinthe.run(query, Schema, context: context)

    assert lists == [%{"title" => list.title, "id" => "#{list.id}"}]

    {:ok, %{data: %{"grokLists" => lists}}} = Absinthe.run(query, Schema)

    assert lists == [
             %{"title" => list.title, "id" => "#{list.id}"},
             %{"title" => list2.title, "id" => "#{list2.id}"}
           ]
  end

  test "a list with items" do
    {:ok, list} = Groceries.create_list(%{title: "A title"})

    item_1 = %{
      text: "spag sauce",
      price: 2.99,
      quantity: 2.0,
      list_id: list.id
    }

    {:ok, _repo_item_1} = Groceries.add_item_to_list(list, item_1)

    item_2 = %{
      text: "salmon",
      price: 19.99,
      quantity: 1.0,
      list_id: list.id
    }

    {:ok, _repo_item_2} = Groceries.add_item_to_list(list, item_2)

    query = """
    {
      grokLists {
        title
        items {
          text
          price
          quantity
        }
      }
    }
    """

    context = %{}

    {:ok, %{data: %{"grokLists" => lists}}} = Absinthe.run(query, Schema, context: context)

    list_1 = hd(lists)
    assert list_1["title"] == list.title

    map_with_string_keys = fn map ->
      Enum.reduce(map, %{}, fn {k, v}, acc ->
        Map.put(acc, Atom.to_string(k), v)
      end)
    end

    list_items = list_1["items"]
    {_val, item_1} = Map.pop(item_1, :list_id)
    {_val, item_2} = Map.pop(item_2, :list_id)

    assert map_with_string_keys.(item_1) in list_items
    assert map_with_string_keys.(item_2) in list_items
  end
end
