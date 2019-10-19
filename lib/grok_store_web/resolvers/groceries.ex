defmodule GrokStoreWeb.Resolvers.Groceries do
  require Logger

  def list_lists(_parent, _args, %{context: %{user: user}}) do
    {:ok, GrokStore.Groceries.list_lists(user)}
  end

  def list_lists(_parent, _args, _context) do
    {:ok, GrokStore.Groceries.list_lists()}
  end

  def list_list_items(list, _args, _context) do
    {:ok, GrokStore.Groceries.list_items_in_list(list)}
  end
end
