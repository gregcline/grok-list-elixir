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

    {:ok, item_1} =
      Groceries.add_item_to_list(list, %{
        text: "spag sauce",
        price: 2.99,
        quantity: 2.0,
        list_id: list.id
      })

    {:ok, item_2} =
      Groceries.add_item_to_list(list, %{
        text: "salmon",
        price: 19.99,
        quantity: 1.0,
        list_id: list.id
      })

    query = """
    {
      lists {
        title
        items {
          id
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

    [first_item, second_item | []] = Enum.sort_by(list_1["items"], & &1["id"])
    assert first_item["text"] == item_1.text
    assert first_item["price"] == item_1.price
    assert first_item["quantity"] == item_1.quantity

    assert second_item["text"] == item_2.text
    assert second_item["price"] == item_2.price
    assert second_item["quantity"] == item_2.quantity
  end
end
