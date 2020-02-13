defmodule GrokStoreWeb.Router do
  use GrokStoreWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug GrokStoreWeb.Auth.Pipeline
    plug GrokStoreWeb.Auth.Context
  end

  scope "/api" do
    pipe_through [:api, :auth]

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: GrokStoreWeb.Schema

    forward "/", Absinthe.Plug, schema: GrokStoreWeb.Schema
  end

  scope "/", GrokStoreWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/404", PageController, :missing

    live "/users/new", UserLive.New
    get "/users/:id", UserController, :show

    get "/login", LoginController, :index
    post "/login", LoginController, :new
    delete "/login", LoginController, :delete
  end
end
