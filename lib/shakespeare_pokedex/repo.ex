defmodule ShakespearePokedex.Repo do
  use Ecto.Repo,
    otp_app: :shakespeare_pokedex,
    adapter: Ecto.Adapters.Postgres
end
