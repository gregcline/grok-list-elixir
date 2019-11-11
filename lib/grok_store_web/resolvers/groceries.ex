defmodule GrokStoreWeb.Resolvers.Groceries do
  require Logger

  alias GrokStore.Groceries
  alias GrokStore.Accounts

  def list_lists(_parent, _args, %{context: %{user: user}}) do
    {:ok, GrokStore.Groceries.list_lists(user)}
  end

  def list_lists(_parent, _args, _context) do
    {:ok, GrokStore.Groceries.list_lists()}
  end

  def list_list_items(list, _args, _context) do
    {:ok, GrokStore.Groceries.list_items_in_list(list)}
  end

  def create_list(_parent, args, %{context: %{user: user}}) do
    {:ok, list} = Groceries.create_list(args)
    {:ok, _user} = Accounts.add_list(user, list)
    {:ok, list}
  end

  def create_list(_parent, _args, _info) do
    {:error, "You must be signed in to create a list"}
  end

  def add_item(_parent, args, %{context: %{user: user}}) do
    case Accounts.get_user_list(user, args[:list_id]) do
      nil ->
        {:error, "You must be a member of the list to add to it"}

      list ->
        GrokStore.Groceries.add_item_to_list(list, args)
    end
  end

  def add_item(_parent, _args, _info) do
    {:error, "You must be signed in to add an item to a list"}
  end
end
