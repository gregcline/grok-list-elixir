defmodule GrokStoreWeb.Resolvers.Accounts do
  alias GrokStoreWeb.Auth.Guardian
  alias GrokStoreWeb.Auth.Helper
  alias GrokStore.Accounts
  alias GrokStore.Repo
  require Logger

  def create_user(%{name: name, email: email, password: password}, _info) do
    Accounts.create_user(%{
      name: name,
      email: email,
      password: password
    })
  end

  def login(%{email: email, password: password}, _info) do
    with {:ok, user} <- Helper.login_with_email_pass(email, password),
         {:ok, jwt, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt}}
    else
      {:error, "invalid password"} ->
        {:error, "invalid credentials"}

      {:error, "invalid user-identifier"} ->
        {:error, "invalid credentials"}
    end
  end

  def find_user(_parent, %{id: id}, _resolution) do
    case GrokStore.Accounts.get_user(id) do
      nil ->
        {:error, "User ID #{id} not found"}

      user ->
        {:ok, user}
    end
  end

  def list_list_users(parent, _args, _info) do
    Logger.info(inspect(parent))
    loaded = Repo.preload(parent, :users)
    Logger.info(inspect(loaded))
    {:ok, loaded.users}
  end
end
