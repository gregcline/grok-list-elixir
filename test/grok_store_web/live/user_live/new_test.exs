defmodule GrokStoreWeb.UserLive.NewTest do
  use GrokStoreWeb.ConnCase
  import Phoenix.LiveViewTest

  test "mount", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/users/new")

    assert html =~ "<h2>Create Your Account</h2>"
    assert html =~ "Name"
    assert html =~ "Email"
    assert html =~ "Password"
    assert html =~ "Password Confirmation"
    assert html =~ "Save"
  end
end
