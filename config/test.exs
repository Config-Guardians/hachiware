import Config

config :hachiware, Hachiware.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "hachiware_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :ash, policies: [show_policy_breakdowns?: true], disable_async?: true

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hachiware, HachiwareWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "mmqABGmbm7e4aY5IQ5HMfruyit38Xt/rgKgqTwofAwn1Fak66ECbfmUFhwpHQApw",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
