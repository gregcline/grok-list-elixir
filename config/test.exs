use Mix.Config

# Configure your database
config :grok_store, GrokStore.Repo,
  username: "postgres",
  password: "postgres",
  database: "grok_store_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :grok_store, GrokStoreWeb.Endpoint,
  http: [port: 4002],
  server: false

# Configuration for JWTs
config :grok_store, GrokStoreWeb.Auth.Guardian,
  issuer: "grok_store",
  secret_key: "ztGCGCj7Gb2fVrHps6zAaPh/NHDvSlHEeyOuERwoX2/2N36+/F0rVKotac4tGIuz"

# Print only warnings and errors during test
config :logger, level: :warn
