defmodule GrokStore.GroceryHelper do
  alias GrokStore.Groceries.List
  alias GrokStore.Groceries

  @valid_attrs %{title: "some title"}

  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Groceries.create_list()

    list
  end
end
