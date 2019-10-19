defmodule GrokStoreWeb.Auth.Helper do
  alias GrokStore.Repo
  alias GrokStore.Accounts.User

  def login_with_email_pass(email, password) do
    Repo.get_by(User, email: email)
    |> Argon2.check_pass(password, hash_key: :passhash)
  end
end
