defmodule GrokStoreWeb.Auth.Guardian do
  use Guardian, otp_app: :grok_store

  alias GrokStore.Accounts
  alias GrokStore.Accounts.User

  def subject_for_token(%User{} = user, _claims) do
    {:ok, user.id}
  end

  def subject_for_token(_, _), do: {:error, :not_authenticated}

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end
end
