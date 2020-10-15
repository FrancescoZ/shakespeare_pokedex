defmodule ShakespearePokedexWeb.PokemonController do
  @moduledoc """
  Manage the pokemon informations
  """
  use ShakespearePokedexWeb, :controller
  alias ShakespearePokedex.PokemonManager

  def get_pokemon(conn, %{"pokemon_name" => pokemon_name}) do
    case PokemonManager.get_info(pokemon_name) do
      {:ok, pokemon} ->
        conn
        |> put_status(200)
        |> render("show.json", pokemon: pokemon)

      _ ->
        conn
        |> put_status(:not_found)
        |> json(:pokemon_not_found)
    end
  end
end
