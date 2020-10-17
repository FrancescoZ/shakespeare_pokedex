defmodule ShakespearePokedex.PokemonManagerTest do
  import Mox
  use ShakespearePokedex.DataCase
  alias ShakespearePokedex.PokemonCache
  use ExUnit.Case, async: false

  @pokemon_name "testMeEasly"
  @pokemon_id "123"
  @valid_pokemon %{
    name: @pokemon_name,
    id: @pokemon_id,
    abilities: ["blaze", "solar-power"]
  }
  @valid_pokemon_no_abilities %{
    name: @pokemon_name,
    id: @pokemon_id,
    abilities: ["nothing"]
  }
  @pokemon_error {:error, "invalid pokemon"}

  @valid_species [
    "When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs."
  ]
  @valid_characteristic ["Loves to eat"]
  @valid_color "black"
  @invalid_color "unknonw"
  @empty {:ok, []}

  @translation "I;m not a poeth what do i know"
  @translation_error {:error, "invalid translation"}

  @pokemon_api ShakespearePokedex.PokemonApiMock
  @translator_api ShakespearePokedex.ShakespeareApiMock
  @subject ShakespearePokedex.PokemonManager

  describe "get_info when cache is empty and pokemon" do
    test "is available returns a pokemon name and a description" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@pokemon_api, :get_species, fn @pokemon_id ->
        {:ok, @valid_species}
      end)

      expect(@pokemon_api, :get_description, fn @pokemon_id ->
        {:ok, @valid_characteristic}
      end)

      expect(@pokemon_api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      expect(
        @translator_api,
        :translate,
        fn "testMeEasly. Its color is black.Loves to eat. It can do: solar-powerblaze.When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs.." ->
          {:ok, @translation}
        end
      )

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description: @translation
             }
    end

    test "is available returns a pokemon name and a description even without abilities" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_no_abilities}
      end)

      expect(@pokemon_api, :get_species, fn @pokemon_id ->
        {:ok, @valid_species}
      end)

      expect(@pokemon_api, :get_description, fn @pokemon_id ->
        {:ok, @valid_characteristic}
      end)

      expect(@pokemon_api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      expect(
        @translator_api,
        :translate,
        fn "testMeEasly. Its color is black.Loves to eat. It can do: nothing.When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs.." ->
          {:ok, @translation}
        end
      )

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description: @translation
             }
    end

    test "is not available returns an error" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        @pokemon_error
      end)

      assert @subject.get_info(@pokemon_name) == {:error, "invalid pokemon"}
    end

    test "is available and the rest is not it returns a pokemon name and a description" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@pokemon_api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      expect(
        @translator_api,
        :translate,
        fn "testMeEasly. Its color is unknonw.. It can do: solar-powerblaze.." ->
          {:ok, @translation}
        end
      )

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description: @translation
             }
    end
  end

  describe "get_info when cache is empty and color" do
    test "is available it returns a pokemon name and description with it" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@pokemon_api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      expect(
        @translator_api,
        :translate,
        fn "testMeEasly. Its color is black.. It can do: solar-powerblaze.." ->
          {:ok, @translation}
        end
      )

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description: @translation
             }
    end

    test "is not available returns a pokemon name and description with unknown color" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@pokemon_api, :get_species, fn @pokemon_id ->
        {:ok, @valid_species}
      end)

      expect(@pokemon_api, :get_description, fn @pokemon_id ->
        {:ok, @valid_characteristic}
      end)

      expect(@pokemon_api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      expect(
        @translator_api,
        :translate,
        fn "testMeEasly. Its color is unknonw.Loves to eat. It can do: solar-powerblaze.When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs.." ->
          {:ok, @translation}
        end
      )

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description: @translation
             }
    end
  end

  describe "get_info when cache is empty and species" do
    test "is available it returns a pokemon name and description with it" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@pokemon_api, :get_species, fn @pokemon_id ->
        {:ok, @valid_species}
      end)

      expect(@pokemon_api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(
        @translator_api,
        :translate,
        fn "testMeEasly. Its color is unknonw.. It can do: solar-powerblaze.When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs.." ->
          {:ok, @translation}
        end
      )

      expect(@pokemon_api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description: @translation
             }
    end

    test "is not available it returns a pokemon name and description without any species" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@pokemon_api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      expect(
        @translator_api,
        :translate,
        fn "testMeEasly. Its color is black.. It can do: solar-powerblaze.." ->
          {:ok, @translation}
        end
      )

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description: @translation
             }
    end
  end

  describe "get_info when cache is empty and abilities" do
    test "is available returns a pokemon name and a description" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@pokemon_api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      expect(
        @translator_api,
        :translate,
        fn "testMeEasly. Its color is unknonw.. It can do: solar-powerblaze.." ->
          {:ok, @translation}
        end
      )

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description: @translation
             }
    end
  end

  describe "get_info when cache is empty and description" do
    test "is available it returns a pokemon name and description with it" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@pokemon_api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_description, fn @pokemon_id ->
        {:ok, @valid_characteristic}
      end)

      expect(@pokemon_api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      expect(
        @translator_api,
        :translate,
        fn "testMeEasly. Its color is unknonw.Loves to eat. It can do: solar-powerblaze.." ->
          {:ok, @translation}
        end
      )

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description: @translation
             }
    end

    test "is not available it returns a pokemon name and description without any species" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@pokemon_api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_color}
      end)

      expect(
        @translator_api,
        :translate,
        fn "testMeEasly. Its color is unknonw.. It can do: solar-powerblaze.." ->
          {:ok, @translation}
        end
      )

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: @pokemon_name,
               description: @translation
             }
    end
  end

  describe "get_info/1 when cache is empty and translation" do
    test "is not available" do
      expect(@pokemon_api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon}
      end)

      expect(@pokemon_api, :get_species, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_description, fn @pokemon_id ->
        @empty
      end)

      expect(@pokemon_api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      expect(
        @translator_api,
        :translate,
        fn "testMeEasly. Its color is black.. It can do: solar-powerblaze.." ->
          @translation_error
        end
      )

      assert @subject.get_info(@pokemon_name) == @translation_error
    end
  end

  describe "get_info/1 when cache is not empty" do
    test "the manager do not call any api" do
      {:ok, pokemon} =
        %{description: "some description", name: @pokemon_name}
        |> PokemonCache.create_pokemon()

      {:ok, answer} = @subject.get_info(@pokemon_name)
      assert answer == %{name: pokemon.name, description: pokemon.description}
    end
  end
end
