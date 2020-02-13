# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :grok_store,
  ecto_repos: [GrokStore.Repo]

# Configures the endpoint
config :grok_store, GrokStoreWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JHg6vbSO8OM12EHL5WEDd+gpjL5LkWeGi8NfhvuHas9/a6ljkkxDar+JTrBk2NOx",
  render_errors: [view: GrokStoreWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GrokStore.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "jEltpqla61RR0U0QqijS+pFBjlp9nMCW"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
