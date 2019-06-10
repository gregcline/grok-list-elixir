defmodule GrokStoreWeb.PageController do
  use GrokStoreWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
