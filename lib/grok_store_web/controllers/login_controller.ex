defmodule GrokStoreWeb.LoginController do
  use GrokStoreWeb, :controller

  alias GrokStore.Accounts.User
  alias GrokStore.Accounts
  alias GrokStoreWeb.Auth.Guardian
  alias GrokStoreWeb.Auth.Helper, as: AuthHelper
  alias GrokStoreWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    if Guardian.Plug.authenticated?(conn) do
      conn
      |> put_flash(:info, "Already logged in")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      changeset = Accounts.change_user(%User{})
      render(conn, "index.html", changeset: changeset)
    end
  end

  def new(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case AuthHelper.login_with_email_pass(email, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Signed in")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        changeset = Accounts.change_user(%User{email: email})

        conn
        |> put_flash(:error, "Login failed")
        |> put_status(401)
        |> render("index.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
