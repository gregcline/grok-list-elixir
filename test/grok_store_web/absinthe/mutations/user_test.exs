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

  describe "create" do
    test "returns user info on creation" do
      query = """
      mutation UserCreate {
        createUser(name: "Aragorn", email: "dunedain@numenor.com", password: "elendil") {
          id
          name
          email
        }
      }
      """

      {:ok, %{data: %{"createUser" => user_info}}} = Absinthe.run(query, Schema)
      user = Accounts.get_user(user_info["id"])
      assert "Aragorn" == user_info["name"] && "Aragorn" == user.name
      assert "dunedain@numenor.com" == user_info["email"] && "dunedain@numenor.com" == user.email
    end

    test "can sign in to created user" do
      query = """
      mutation UserCreate {
        createUser(name: "Aragorn", email: "dunedain@numenor.com", password: "elendil") {
          id
        }
      }
      """

      {:ok, %{data: %{"createUser" => user_info}}} = Absinthe.run(query, Schema)

      query = """
      mutation UserLogin {
        login(email: "dunedain@numenor.com", password: "elendil") {
          token
        }
      }
      """

      {:ok, %{data: %{"login" => %{"token" => token}}}} = Absinthe.run(query, Schema)
      {:ok, claims} = Guardian.decode_and_verify(token)
      assert user_info["id"] == "#{claims["sub"]}"
    end
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
