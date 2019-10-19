defmodule GrokStoreWeb.Resolvers.Accounts do
  alias GrokStoreWeb.Auth.Guardian
  alias GrokStoreWeb.Auth.Helper

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
end
