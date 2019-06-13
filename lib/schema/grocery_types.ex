defmodule GrokStoreWeb.Schema.GroceryTypes do
  use Absinthe.Schema.Notation

  alias GrokStoreWeb.Resolvers

  @desc "A grocery list"
  object :list do
    field :id, :id
    field :title, :string

    field :items, list_of(:item) do
      resolve(&Resolvers.Groceries.list_list_items/3)
    end
  end

  @desc "An item in a grocery list"
  object :item do
    field :id, :id
    field :checked, :boolean
    field :location, :string
    field :price, :float
    field :quantity, :integer
    field :text, :string
  end
end
