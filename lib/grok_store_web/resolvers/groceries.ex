defmodule GrokStoreWeb.Resolvers.Groceries do
  def list_lists(_parent, _args, _context) do
    {:ok, GrokStore.Groceries.list_lists()}
  end

  def list_list_items(list, _args, _context) do
    {:ok, GrokStore.Groceries.list_items_in_list(list)}
  end
end
