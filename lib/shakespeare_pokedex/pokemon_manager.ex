defmodule ShakespearePokedex.PokemonManager do
  @moduledoc """
  Retrieve the pokemon information
  """

  def get_info(pokemon_name) do
    {:ok, %{name: pokemon_name, description: ""}}
  end
end
