defmodule GrokStoreWeb.LoginControllerTest do
  use GrokStoreWeb.ConnCase

  alias GrokStore.Accounts
  alias GrokStoreWeb.Auth.Guardian

  setup do
    {:ok, user} =
      Accounts.create_user(%{
        name: "Scraps",
        email: "scrap@scrap.com",
        password: "a password"
      })

    {:ok, user: user}
  end

  describe "GET /login" do
    test "renders a login page", %{conn: conn} do
      conn = get(conn, "/login")

      assert html_response(conn, 200) =~ "<label for=\"user_email\">Email</label>"
      assert html_response(conn, 200) =~ "<label for=\"user_password\">Password</label>"
      assert html_response(conn, 200) =~ "<button type=\"submit\">Login"
    end
  end

  describe "POST /login" do
    test "flashes logged in when successful", %{conn: conn, user: user} do
      conn =
        post(conn, "/login", %{"user" => %{"email" => user.email, "password" => user.password}})

      assert get_flash(conn, :info) == "Signed in"
    end

    test "token in session when logged in", %{conn: conn, user: user} do
      conn =
        post(conn, "/login", %{"user" => %{"email" => user.email, "password" => user.password}})

      token = Guardian.Plug.current_token(conn)
      assert {:ok, token} = Guardian.decode_and_verify(token)
    end

    test "flashes login failed when unsuccessful", %{conn: conn} do
      conn =
        post(
          conn,
          "/login",
          %{
            "user" => %{
              "email" => "bad@email.com",
              "password" => "badpass"
            }
          }
        )

      assert get_flash(conn, :error) == "Login failed"
    end

    test "leaves email in place on failed login", %{conn: conn} do
      conn =
        post(
          conn,
          "/login",
          %{
            "user" => %{
              "email" => "bad@email.com",
              "password" => "badpass"
            }
          }
        )

      assert html_response(conn, 401) =~
               "<input id=\"user_email\" name=\"user[email]\" type=\"email\" value=\"bad@email.com\">"
    end
  end

  describe "DELETE /login" do
    test "logs the user out", %{conn: conn, user: user} do
      conn =
        conn
        |> post("/login", %{"user" => %{"email" => user.email, "password" => user.password}})
        |> delete("/login")

      assert Guardian.Plug.current_token(conn) == nil
    end
  end
end
