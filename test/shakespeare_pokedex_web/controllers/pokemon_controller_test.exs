defmodule ShakespearePokedexWeb.PokemonControllerTest do
  import Mox
  use ShakespearePokedexWeb.ConnCase, async: true

  @manager ShakespearePokedex.PokemonManagerMock
  @pokemon_name "yetAnotherTestname"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "/pokemon" do
    test "return the pokemon object", %{conn: conn} do
      expect(@manager, :get_info, fn @pokemon_name ->
        {:ok, %{name: @pokemon_name, description: "noOneWillSeethis"}}
      end)

      conn = get(conn, Routes.pokemon_path(conn, :get_pokemon, @pokemon_name))

      assert json_response(conn, 200) == %{
               "name" => @pokemon_name,
               "description" => "noOneWillSeethis"
             }
    end

    test "return an error", %{conn: conn} do
      expect(@manager, :get_info, fn @pokemon_name ->
        {:error, "something went wrong, did I test it all?"}
      end)

      conn = get(conn, Routes.pokemon_path(conn, :get_pokemon, @pokemon_name))

      assert json_response(conn, 404) == "something went wrong, did I test it all?"
    end

    test "return an unknon error", %{conn: conn} do
      expect(@manager, :get_info, fn @pokemon_name ->
        {:timeout, "opsTooktooLong"}
      end)

      conn = get(conn, Routes.pokemon_path(conn, :get_pokemon, @pokemon_name))

      assert json_response(conn, 404) == "unknown_error"
    end
  end
end
