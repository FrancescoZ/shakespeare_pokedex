# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :shakespeare_pokedex,
  ecto_repos: [ShakespearePokedex.Repo],
  pokemon_api_url: System.get_env("POKEMON_INFO"),
  fuse_options: {{:standard, 2, 10_000}, {:reset, 60_000}},
  pokemon_api: ShakespearePokedex.PokemonApi,
  pokemon_manager: ShakespearePokedex.PokemonManager,
  shakespeare_api: ShakespearePokedex.ShakespeareApi,
  shakespeare_api_url: System.get_env("TRANSLATION_URL"),
  gateway_timeout: 20_00

# Configures the endpoint
config :shakespeare_pokedex, ShakespearePokedexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "p6OaJQQkTVNFJeC/MwpFsXHPiRFJwSeRCaQG4xkTTqmLWj39Egy2CTzd360hpTpr",
  render_errors: [view: ShakespearePokedexWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ShakespearePokedex.PubSub,
  live_view: [signing_salt: "7+q5rYX5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
