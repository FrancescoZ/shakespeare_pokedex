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

  @pokemon_id "123"
  @valid_pokemon_response %{
    "abilities" => [
      %{
        "ability" => %{
          "name" => "blaze",
          "url" => "https =>//pokeapi.co/api/v2/ability/66/"
        },
        "is_hidden" => false,
        "slot" => 1
      },
      %{
        "ability" => %{
          "name" => "solar-power",
          "url" => "https =>//pokeapi.co/api/v2/ability/94/"
        },
        "is_hidden" => true,
        "slot" => 3
      }
    ],
    "name" => @pokemon_name,
    "order" => 7,
    "species" => %{
      "name" => "charizard",
      "url" => "https =>//pokeapi.co/api/v2/pokemon-species/6/"
    },
    "id" => @pokemon_id
  }
  @valid_characteristic_response %{
    "id" => 1,
    "gene_modulo" => 0,
    "highest_stat" => %{
      "name" => "hp",
      "url" => "https=> //pokeapi.co/api/v2/stat/1/"
    },
    "descriptions" => [
      %{
        "description" => "Loves to eat",
        "language" => %{
          "name" => "en",
          "url" => "https=> //pokeapi.co/api/v2/language/9/"
        }
      }
    ]
  }
  @valid_characteristic_response_escaped %{
    "id" => 1,
    "gene_modulo" => 0,
    "highest_stat" => %{
      "name" => "hp",
      "url" => "https=> //pokeapi.co/api/v2/stat/1/"
    },
    "descriptions" => [
      %{
        "description" => "Loves\nto eat",
        "language" => %{
          "name" => "en",
          "url" => "https=> //pokeapi.co/api/v2/language/9/"
        }
      }
    ]
  }
  @valid_species_response %{
    "id" => 413,
    "flavor_text_entries" => [
      %{
        "flavor_text" =>
          "When the bulb on\nits back grows\nlarge, it appears\fto lose the\nability to stand\non its hind legs.",
        "language" => %{
          "name" => "en",
          "url" => "https=> //pokeapi.co/api/v2/language/9/"
        },
        "version" => %{
          "name" => "red",
          "url" => "https=> //pokeapi.co/api/v2/version/1/"
        }
      }
    ],
    "form_descriptions" => [
      %{
        "description" =>
          "Forms have different stats and movepools.  During evolution, Burmy's current cloak becomes Wormadam's form, and can no longer be changed.",
        "language" => %{
          "name" => "en",
          "url" => "https=> //pokeapi.co/api/v2/language/9/"
        }
      }
    ],
    "genera" => [
      %{
        "genus" => "Bagworm",
        "language" => %{
          "name" => "en",
          "url" => "https=> //pokeapi.co/api/v2/language/9/"
        }
      }
    ]
  }
  @valid_species_response_2 %{
    "id" => 413,
    "form_descriptions" => [
      %{
        "description" =>
          "Forms have different stats and movepools.  During evolution, Burmy's current cloak becomes Wormadam's form, and can no longer be changed.",
        "language" => %{
          "name" => "en",
          "url" => "https=> //pokeapi.co/api/v2/language/9/"
        }
      }
    ],
    "genera" => [
      %{
        "genus" => "Bagworm",
        "language" => %{
          "name" => "en",
          "url" => "https=> //pokeapi.co/api/v2/language/9/"
        }
      }
    ]
  }
  @valid_color_response %{
    "id" => 1,
    "name" => "black",
    "names" => [
      %{
        "name" => "é»’ã„",
        "language" => %{
          "name" => "ja",
          "url" => "https=> //pokeapi.co/api/v2/language/1/"
        }
      }
    ],
    "pokemon_species" => [
      %{
        "name" => "snorlax",
        "url" => "https=> //pokeapi.co/api/v2/pokemon-species/143/"
      }
    ]
  }

  @empty_result {:ok, []}
  @invalid_answer %{
    something: "invalid"
  }

  @valid_pokemon %{
    name: @pokemon_name,
    id: @pokemon_id,
    abilities: ["blaze", "solar-power"]
  }
  @valid_species [
    "When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs."
  ]
  @valid_species_2 [
    "Forms have different stats and movepools.  During evolution, Burmy's current cloak becomes Wormadam's form, and can no longer be changed."
  ]
  @valid_charateristics ["Loves to eat"]
  @valid_color "black"
  @invalid_color "unknonw"

  setup do
    :fuse.reset(@subject)
    :ok
  end

  describe "get_pokemon/1" do
    test "returns a correct value with all info" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @valid_pokemon_response}}
      end)

      {:ok, result} = @subject.get_pokemon(@pokemon_name)

      assert result == @valid_pokemon
    end

    test "returns a correct values without abilities" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: %{
             "name" => @pokemon_name,
             "order" => 7,
             "species" => %{
               "name" => "charizard",
               "url" => "https =>//pokeapi.co/api/v2/pokemon-species/6/"
             },
             "id" => @pokemon_id
           }
         }}
      end)

      {:ok, result} = @subject.get_pokemon(@pokemon_name)

      assert result == %{name: @pokemon_name, id: @pokemon_id, abilities: ["nothing"]}
    end

    test "returns an error when is not a pokemon strucuture" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: %{
             "first_name" => "notAvalid",
             "last_name" => "pokemon"
           }
         }}
      end)

      assert {:error, "invalid pokemon"} = @subject.get_pokemon(@pokemon_name)
    end

    test "receives a known error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:error, :unavailable}
      end)

      assert {:error, "invalid pokemon"} = @subject.get_pokemon(@pokemon_name)
    end

    test "receives an unknown error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:error, "stange error generated"}
      end)

      assert {:error, "invalid pokemon"} = @subject.get_pokemon(@pokemon_name)
    end

    test "receives a 400" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:ok, %Tesla.Env{status: 400, body: "Random 400 error"}}
      end)

      assert {:error, "invalid pokemon"} == @subject.get_pokemon(@pokemon_name)
    end

    test "receives a 500" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:ok, %Tesla.Env{status: 500}}
      end)

      assert {:error, "invalid pokemon"} = @subject.get_pokemon(@pokemon_name)
    end

    test "receives a 300" do
      expect(@http_client, :call, fn %{method: :get, url: @get_pokemon_url}, _opts ->
        {:ok, %Tesla.Env{status: 300, body: "Random 300 error"}}
      end)

      assert {:error, "invalid pokemon"} ==
               @subject.get_pokemon(@pokemon_name)
    end
  end

  describe "get_description/1" do
    test "returns a correct value" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @valid_characteristic_response}}
      end)

      {:ok, result} = @subject.get_description(@pokemon_id)

      assert result == @valid_charateristics
    end

    test "returns a correct value escaped by special character" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @valid_characteristic_response_escaped}}
      end)

      {:ok, result} = @subject.get_description(@pokemon_id)

      assert result == @valid_charateristics
    end

    test "receives an invalid description object" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @invalid_answer}}
      end)

      assert @empty_result = @subject.get_description(@pokemon_id)
    end

    test "receives a known error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:error, :unavailable}
      end)

      assert @empty_result = @subject.get_description(@pokemon_id)
    end

    test "receives an unknown error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:error, "stange error generated"}
      end)

      assert @empty_result = @subject.get_description(@pokemon_id)
    end

    test "receives a 400" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:ok, %Tesla.Env{status: 400, body: "Random 400 error"}}
      end)

      assert @empty_result == @subject.get_description(@pokemon_id)
    end

    test "receives a 500" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:ok, %Tesla.Env{status: 500}}
      end)

      assert @empty_result = @subject.get_description(@pokemon_id)
    end

    test "receives a 300" do
      expect(@http_client, :call, fn %{method: :get, url: @get_description_url}, _opts ->
        {:ok, %Tesla.Env{status: 300, body: "Random 300 error"}}
      end)

      assert @empty_result ==
               @subject.get_description(@pokemon_id)
    end
  end

  describe "get_species/1" do
    test "returns a correct value" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @valid_species_response}}
      end)

      {:ok, result} = @subject.get_species(@pokemon_id)

      assert result == @valid_species
    end

    test "returns a correct value even if it receives duplicates" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: %{
             "flavor_text_entries" => [
               %{
                 "flavor_text" =>
                   "When the bulb on\nits back grows\nlarge, it appears\fto lose the\nability to stand\non its hind legs.",
                 "language" => %{
                   "name" => "en",
                   "url" => "https=> //pokeapi.co/api/v2/language/9/"
                 },
                 "version" => %{
                   "name" => "red",
                   "url" => "https=> //pokeapi.co/api/v2/version/1/"
                 }
               },
               %{
                 "flavor_text" =>
                   "When the bulb on\nits back grows\nlarge, it appears\fto lose the\nability to stand\non its hind legs.",
                 "language" => %{
                   "name" => "en",
                   "url" => "https=> //pokeapi.co/api/v2/language/9/"
                 },
                 "version" => %{
                   "name" => "red",
                   "url" => "https=> //pokeapi.co/api/v2/version/1/"
                 }
               },
               %{
                 "flavor_text" =>
                   "When the bulb on\nits back grows\nlarge, it appears\fto lose the\nability to stand\non its hind legs.",
                 "language" => %{
                   "name" => "en",
                   "url" => "https=> //pokeapi.co/api/v2/language/9/"
                 },
                 "version" => %{
                   "name" => "red",
                   "url" => "https=> //pokeapi.co/api/v2/version/1/"
                 }
               }
             ]
           }
         }}
      end)

      {:ok, result} = @subject.get_species(@pokemon_id)

      assert result == @valid_species
    end

    test "returns a correct value even if only form description is there" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @valid_species_response_2}}
      end)

      {:ok, result} = @subject.get_species(@pokemon_id)

      assert result == @valid_species_2
    end

    test "receives a invalid object structure" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @invalid_answer}}
      end)

      assert @empty_result = @subject.get_species(@pokemon_id)
    end

    test "receives a known error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:error, :unavailable}
      end)

      assert @empty_result = @subject.get_species(@pokemon_id)
    end

    test "receives an unknown error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:error, "stange error generated"}
      end)

      assert @empty_result = @subject.get_species(@pokemon_id)
    end

    test "receives a 400" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:ok, %Tesla.Env{status: 400, body: "Random 400 error"}}
      end)

      assert @empty_result == @subject.get_species(@pokemon_id)
    end

    test "receives a 500" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:ok, %Tesla.Env{status: 500}}
      end)

      assert @empty_result = @subject.get_species(@pokemon_id)
    end

    test "receives a 300" do
      expect(@http_client, :call, fn %{method: :get, url: @get_species_url}, _opts ->
        {:ok, %Tesla.Env{status: 300, body: "Random 300 error"}}
      end)

      assert @empty_result ==
               @subject.get_species(@pokemon_id)
    end
  end

  describe "get_color/1" do
    test "returns a correct value" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @valid_color_response}}
      end)

      {:ok, result} = @subject.get_color(@pokemon_id)

      assert result == @valid_color
    end

    test "receives an wrong sturcture" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: @invalid_answer}}
      end)

      assert {:ok, @invalid_color} = @subject.get_color(@pokemon_id)
    end

    test "receives a known error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:error, :unavailable}
      end)

      assert {:ok, @invalid_color} = @subject.get_color(@pokemon_id)
    end

    test "receives an unknown error" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:error, "stange error generated"}
      end)

      assert {:ok, @invalid_color} = @subject.get_color(@pokemon_id)
    end

    test "receives a 400" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:ok, %Tesla.Env{status: 400, body: "Random 400 error"}}
      end)

      assert {:ok, @invalid_color} == @subject.get_color(@pokemon_id)
    end

    test "receives a 500" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:ok, %Tesla.Env{status: 500}}
      end)

      assert {:ok, @invalid_color} = @subject.get_color(@pokemon_id)
    end

    test "receives a 300" do
      expect(@http_client, :call, fn %{method: :get, url: @get_color_url}, _opts ->
        {:ok, %Tesla.Env{status: 300, body: "Random 300 error"}}
      end)

      assert {:ok, @invalid_color} ==
               @subject.get_color(@pokemon_id)
    end
  end
end
