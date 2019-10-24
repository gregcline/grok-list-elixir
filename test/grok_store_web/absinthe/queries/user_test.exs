defmodule GrokStoreWeb.Absinthe.Queries.UserTest do
  use GrokStoreWeb.ConnCase
  alias GrokStoreWeb.Schema
  alias GrokStore.Accounts

  setup do
    {:ok, user} =
      Accounts.create_user(%{
        name: "Keanu Reeves",
        email: "keanu@coolguy.com",
        password: "a password"
      })

    {:ok, user: user}
  end

  test "getting a user", %{user: user} do
    query = """
    {
      user(id: #{user.id}) {
        name
        email
      }
    }
    """

    {:ok, %{data: %{"user" => new_user}}} = Absinthe.run(query, Schema)

    assert new_user["name"] == user.name
    assert new_user["email"] == user.email
  end
end
