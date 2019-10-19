defmodule GrokStoreWeb.Absinthe.Queries.UserTest do
  use GrokStoreWeb.ConnCase
  alias GrokStoreWeb.Schema
  alias GrokStore.Accounts
  alias GrokStoreWeb.Auth.Guardian

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

  describe "login" do
    test "returns a token for user with correct credentials", %{user: user} do
      query = """
      mutation UserLogin {
        login(email: "keanu@coolguy.com", password: "a password") {
          token
        }
      }
      """

      {:ok, %{data: %{"login" => %{"token" => token}}}} = Absinthe.run(query, Schema)
      {:ok, claims} = Guardian.decode_and_verify(token)
      assert user.id == claims["sub"]
    end

    test "returns an error for incorrect password", %{user: _user} do
      query = """
      mutation UserLogin {
        login(email: "keanu@coolguy.com", password: "pass") {
          token
        }
      }
      """

      assert {:ok,
              %{
                data: %{"login" => nil},
                errors: [
                  %{
                    locations: [%{column: 0, line: 2}],
                    message: "invalid credentials",
                    path: ["login"]
                  }
                ]
              }} == Absinthe.run(query, Schema)
    end

    test "rejects non-existent user" do
      query = """
      mutation UserLogin {
        login(email: "foo@bar.com", password: "pass") {
          token
        }
      }
      """

      assert {:ok,
              %{
                data: %{"login" => nil},
                errors: [
                  %{
                    locations: [%{column: 0, line: 2}],
                    message: "invalid credentials",
                    path: ["login"]
                  }
                ]
              }} == Absinthe.run(query, Schema)
    end
  end
end
