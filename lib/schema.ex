defmodule GrokStoreWeb.Schema do
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)
  import_types(GrokStoreWeb.Schema.GroceryTypes)
  import_types(GrokStoreWeb.Schema.AccountTypes)

  alias GrokStoreWeb.Resolvers

  query do
    @desc "Get all lists"
    field :grok_lists, list_of(:grok_list) do
      resolve(&Resolvers.Groceries.list_lists/3)
    end

    @desc "Get a user by id"
    field :user, :user do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Accounts.find_user/3)
    end
  end

  mutation do
    @desc "Register a user"
    field :create_user, type: :user do
      arg(:name, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.create_user/2)
    end

    @desc "Sign in a user"
    field :login, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.login/2)
    end

    @desc "Create a list for the signed in user. Will error if there is not user signed in"
    field :create_list, type: :grok_list do
      arg(:title, non_null(:string))
      resolve(&Resolvers.Groceries.create_list/3)
    end

    @desc "Adds an item to the list"
    field :add_item, type: :item do
      arg(:text, non_null(:string))
      arg(:price, :float)
      arg(:quantity, :float)
      arg(:list_id, :id)
      resolve(&Resolvers.Groceries.add_item/3)
    end

    @desc "Toggles the checked status on an item"
    field :check_item, type: :item do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Groceries.check_item/3)
    end
  end
end
