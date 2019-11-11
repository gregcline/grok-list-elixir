defmodule GrokStoreWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  @desc "A user"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
  end

  @desc "A user access token"
  object :session do
    field :token, :string
  end
end
