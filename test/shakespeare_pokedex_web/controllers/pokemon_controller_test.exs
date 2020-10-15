defmodule ShakespearePokedexWeb.PokemonControllerTest do
  use ShakespearePokedexWeb.ConnCase, async: true

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "/pokemon", %{conn: conn} do
    conn = get(conn, Routes.pokemon_path(conn, :get_pokemon, "test"))

    assert json_response(conn, 200) == %{
             "name" => "test",
             "description" => ""
           }
  end
end
