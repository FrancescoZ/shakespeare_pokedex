defmodule ShakespearePokedex.PokemonManagerTest do
  use ShakespearePokedex.DataCase
  use ExUnit.Case, async: false

  @subject ShakespearePokedex.PokemonManager

  test "get_info" do
    {:ok, answer} = @subject.get_info("testMeEasly")

    assert answer == %{
             name: "testMeEasly",
             description: ""
           }
  end
end
