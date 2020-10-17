defmodule ShakespearePokedexWeb.PokemonController do
  @moduledoc """
  Manage the pokemon informations
  """
  use ShakespearePokedexWeb, :controller
  @manager Application.get_env(:shakespeare_pokedex, :pokemon_manager)

  def get_pokemon(conn, %{"pokemon_name" => pokemon_name}) do
    case @manager.get_info(pokemon_name) do
      {:ok, pokemon} ->
        conn
        |> put_status(200)
        |> render("show.json", pokemon: pokemon)
      {:error, error} ->
        conn
        |> put_status(:not_found)
        |> json(error)
      _ ->
        conn
        |> put_status(:not_found)
        |> json(:unknown_error)
    end
  end
end
