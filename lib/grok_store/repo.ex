defmodule GrokStore.Repo do
  use Ecto.Repo,
    otp_app: :grok_store,
    adapter: Ecto.Adapters.Postgres
end
