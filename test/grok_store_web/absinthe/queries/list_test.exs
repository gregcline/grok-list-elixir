defmodule GrokStoreWeb.Absinthe.Queries.ListTest do
  use GrokStoreWeb.ConnCase
  alias GrokStoreWeb.Schema
  alias GrokStore.Groceries

  test "getting a list" do
    {:ok, list} = Groceries.create_list(%{title: "A title"})

    query = """
    {
      lists {
        id
        title
      }
    }
    """

    # will use the context once we have logged in users
    context = %{}

    {:ok, %{data: %{"lists" => lists}}} = Absinthe.run(query, Schema, context: context)

    first_list = hd(lists)
    assert first_list["title"] == list.title
    assert Integer.parse(first_list["id"]) == {list.id, ""}
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
      lists {
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

    {:ok, %{data: %{"lists" => lists}}} = Absinthe.run(query, Schema, context: context)

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
