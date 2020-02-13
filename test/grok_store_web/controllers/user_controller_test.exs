defmodule GrokStoreWeb.UserControllerTest do
  use GrokStoreWeb.ConnCase

  alias GrokStore.Accounts

  setup do
    {:ok, user} =
      Accounts.create_user(%{
        name: "Scraps",
        email: "scrap@scrap.com",
        password: "a password"
      })

    {:ok, user: user}
  end

  describe "GET /users/:id" do
    test "an existing user", %{conn: conn, user: user} do
      conn = get(conn, "/users/#{user.id}")
      assert html_response(conn, 200) =~ "<b>Name:</b> Scraps"
      assert html_response(conn, 200) =~ "<b>Email:</b> scrap@scrap.com"
    end

    test "a non-existent user", %{conn: conn} do
      conn = get(conn, "/users/-1")
      assert html_response(conn, 404) =~ "Sorry, nothing here"
    end
  end
end
