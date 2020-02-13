defmodule GrokStoreWeb.PageController do
  use GrokStoreWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def missing(conn, _params) do
    render(conn, "404.html")
  end
end
