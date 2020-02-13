defmodule GrokStoreWeb.UserController do
  use GrokStoreWeb, :controller

  alias GrokStore.Accounts

  def show(conn, %{"id" => id}) do
    case Accounts.get_user(id) do
      nil ->
        conn
        |> put_flash(:error, "User does not exist")
        |> put_view(GrokStoreWeb.PageView)
        |> put_status(404)
        |> render("404.html")

      user ->
        render(conn, "show.html", user: user)
    end
  end
end
