defmodule GrokStoreWeb.PageControllerTest do
  use GrokStoreWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Phoenix"
  end

  test "GET /404", %{conn: conn} do
    conn = get(conn, "/404")
    assert html_response(conn, 200) =~ "Sorry, nothing here"
  end
end
