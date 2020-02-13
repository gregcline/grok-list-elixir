defmodule GrokStoreWeb.LoginController do
  use GrokStoreWeb, :controller

  alias GrokStore.Accounts.User
  alias GrokStore.Accounts
  alias GrokStoreWeb.Auth.Helper
  alias GrokStoreWeb.Auth.Guardian
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

  def new(conn, %{"email" => email, "password" => password}) do
    conn
    |> Guardian.Plug.sign_in()
  end
end
