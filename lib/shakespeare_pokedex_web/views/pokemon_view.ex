defmodule ShakespearePokedexWeb.PokemonView do
  use ShakespearePokedexWeb, :view

  def render("index.json", %{pokemons: results}) do
    %{pokemons: render_many(results, __MODULE__, "result.json")}
  end

  def render("show.json", %{pokemon: result}) do
    render_one(result, __MODULE__, "result.json")
  end

  def render("result.json", %{pokemon: result}) do
    %{
      name: result.name,
      description: result.description
    }
  end
end
