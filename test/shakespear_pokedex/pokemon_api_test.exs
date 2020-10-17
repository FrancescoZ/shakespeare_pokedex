defmodule ShakespearePokedex.PokemonApiTest do
  use ExUnit.Case, async: true
  import Mox

  setup :verify_on_exit!

  @pokemon_name "testME"
  @pokemon_id "123"
  @url Application.get_env(:shakespeare_pokedex, :pokemon_api_url)
  @get_pokemon_url @url <> "pokemon/#{@pokemon_name}"
  @get_description_url @url <> "characteristic/#{@pokemon_id}"
  @get_species_url @url <> "pokemon-species/#{@pokemon_id}"
  @get_color_url @url <> "pokemon-color/#{@pokemon_id}"

  @http_client Application.get_env(:tesla, :adapter)

  @subject ShakespearePokedex.PokemonApi

  @valid_response %{
    thisIS: %{
      a: "valid",
      object: [
        %{
          returned: "cccc"
        }
      ]
    }
  }

  setup do
    :fuse.reset(@subject)
    :ok
  end

  describe "get_pokemon/1" do
    test "returns a correct value" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @valid_response}}
      end)

      {:ok, result} = @subject.get_pokemon(@pokemon_name)

      assert result == @valid_response
    end

    test "returns a known error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:error, :unavailable}
      end)

      assert {:error, _} = @subject.get_pokemon(@pokemon_name)
    end

    test "returns an unknown error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:error, "stange error generated"}
      end)

      assert {:error, _} = @subject.get_pokemon(@pokemon_name)
    end

    test "returns a 400" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:ok, %Tesla.Env{status: 400, body: "Random 400 error"}}
      end)

      assert {:error, "client_error"} == @subject.get_pokemon(@pokemon_name)
    end

    test "returns a 500" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:ok, %Tesla.Env{status: 500}}
      end)

      assert {:error, _} = @subject.get_pokemon(@pokemon_name)
    end

    test "returns a 300" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:ok, %Tesla.Env{status: 300, body: "Random 300 error"}}
      end)

      assert {:error, "Generic error"} ==
               @subject.get_pokemon(@pokemon_name)
    end
  end

  describe "get_description/1" do
    test "returns a correct value" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @valid_response}}
      end)

      {:ok, result} = @subject.get_description(@pokemon_id)

      assert result == @valid_response
    end

    test "returns a known error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:error, :unavailable}
      end)

      assert {:error, _} = @subject.get_description(@pokemon_id)
    end

    test "returns an unknown error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:error, "stange error generated"}
      end)

      assert {:error, _} = @subject.get_description(@pokemon_id)
    end

    test "returns a 400" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:ok, %Tesla.Env{status: 400, body: "Random 400 error"}}
      end)

      assert {:error, "client_error"} == @subject.get_description(@pokemon_id)
    end

    test "returns a 500" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:ok, %Tesla.Env{status: 500}}
      end)

      assert {:error, _} = @subject.get_description(@pokemon_id)
    end

    test "returns a 300" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:ok, %Tesla.Env{status: 300, body: "Random 300 error"}}
      end)

      assert {:error, "Generic error"} ==
               @subject.get_description(@pokemon_id)
    end
  end

  describe "get_species/1" do
    test "returns a correct value" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @valid_response}}
      end)

      {:ok, result} = @subject.get_species(@pokemon_id)

      assert result == @valid_response
    end

    test "returns a known error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:error, :unavailable}
      end)

      assert {:error, _} = @subject.get_species(@pokemon_id)
    end

    test "returns an unknown error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:error, "stange error generated"}
      end)

      assert {:error, _} = @subject.get_species(@pokemon_id)
    end

    test "returns a 400" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:ok, %Tesla.Env{status: 400, body: "Random 400 error"}}
      end)

      assert {:error, "client_error"} == @subject.get_species(@pokemon_id)
    end

    test "returns a 500" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:ok, %Tesla.Env{status: 500}}
      end)

      assert {:error, _} = @subject.get_species(@pokemon_id)
    end

    test "returns a 300" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:ok, %Tesla.Env{status: 300, body: "Random 300 error"}}
      end)

      assert {:error, "Generic error"} ==
               @subject.get_species(@pokemon_id)
    end
  end

  describe "get_color/1" do
    test "returns a correct value" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @valid_response}}
      end)

      {:ok, result} = @subject.get_color(@pokemon_id)

      assert result == @valid_response
    end

    test "returns a known error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:error, :unavailable}
      end)

      assert {:error, _} = @subject.get_color(@pokemon_id)
    end

    test "returns an unknown error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:error, "stange error generated"}
      end)

      assert {:error, _} = @subject.get_color(@pokemon_id)
    end

    test "returns a 400" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:ok, %Tesla.Env{status: 400, body: "Random 400 error"}}
      end)

      assert {:error, "client_error"} == @subject.get_color(@pokemon_id)
    end

    test "returns a 500" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:ok, %Tesla.Env{status: 500}}
      end)

      assert {:error, _} = @subject.get_color(@pokemon_id)
    end

    test "returns a 300" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:ok, %Tesla.Env{status: 300, body: "Random 300 error"}}
      end)

      assert {:error, "Generic error"} ==
               @subject.get_color(@pokemon_id)
    end
  end
end
