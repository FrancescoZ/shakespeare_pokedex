defmodule ShakespearePokedexWeb.PokemonViewTest do
  use ShakespearePokedexWeb.ConnCase, async: true

  import Phoenix.View

  test "renders pokemon" do
    assert render(ShakespearePokedexWeb.PokemonView, "show.json",
             pokemon: %{name: "TestMeView", description: "IDontknow"}
           ) == %{
             name: "TestMeView",
             description: "IDontknow"
           }
  end

  test "renders pokemons" do
    assert render(ShakespearePokedexWeb.PokemonView, "index.json",
             pokemons: [
               %{name: "TestMeView2", description: "maybe"},
               %{name: "TestMeView3", description: "Iknow"}
             ]
           ) == %{
             pokemons: [
               %{
                 name: "TestMeView2",
                 description: "maybe"
               },
               %{
                 name: "TestMeView3",
                 description: "Iknow"
               }
             ]
           }
  end
end
