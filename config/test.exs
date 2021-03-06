use Mix.Config

# Configure your database
config :rumbl, Rumbl.Repo,
  username: "postgres",
  password: "postgres",
  database: "rumbl_test",
  hostname: "pgsql-db",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rumbl, RumblWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger,
  level: :warn

# Configure password hashing function
config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :rumbl, :wolfram,
  app_id: "1234",
  http_client: InfoSys.Test.HTTPClient
