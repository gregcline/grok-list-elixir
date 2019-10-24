defmodule GrokStoreWeb.Schema do
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)
  import_types(GrokStoreWeb.Schema.GroceryTypes)
  import_types(GrokStorWeb.Schema.AccountTypes)

  alias GrokStoreWeb.Resolvers

  query do
    @desc "Get all lists"
    field :lists, list_of(:list) do
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
  end
end
