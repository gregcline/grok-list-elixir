defmodule GrokStoreWeb.Schema do
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)
  import_types(GrokStoreWeb.Schema.GroceryTypes)

  alias GrokStoreWeb.Resolvers

  query do
    @desc "Get all lists"
    field :lists, list_of(:list) do
      resolve(&Resolvers.Groceries.list_lists/3)
    end
  end
end
