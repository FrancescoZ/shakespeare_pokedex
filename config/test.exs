use Mix.Config

config :shakespeare_pokedex,
  pokemon_api: ShakespearePokedex.PokemonApiMock,
  pokemon_manager: ShakespearePokedex.PokemonManagerMock,
  shakespeare_api: ShakespearePokedex.ShakespeareApiMock

config :shakespeare_pokedex, ShakespearePokedex.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: System.get_env("POSTGRES_HOSTNAME"),
  database: "shakespeare_pokedex_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :shakespeare_pokedex, ShakespearePokedexWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :tesla, adapter: ShakespearePokedex.TeslaMock
