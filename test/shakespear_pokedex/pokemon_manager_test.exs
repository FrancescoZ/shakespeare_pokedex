defmodule ShakespearePokedex.PokemonManagerTest do
  import Mox
  use ShakespearePokedex.DataCase
  use ExUnit.Case, async: false

  @pokemon_name "testMeEasly"
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
    "name" => "charizard",
    "order" => 7,
    "species" => %{
      "name" => "charizard",
      "url" => "https =>//pokeapi.co/api/v2/pokemon-species/6/"
    },
    "id" => @pokemon_id
  }
  @valid_characteristic %{
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
  @valid_species %{
    "id" => 413,
    "name" => "wormadam",
    "order" => 441,
    "gender_rate" => 8,
    "capture_rate" => 45,
    "base_happiness" => 70,
    "is_baby" => false,
    "is_legendary" => false,
    "is_mythical" => false,
    "hatch_counter" => 15,
    "has_gender_differences" => false,
    "forms_switchable" => false,
    "evolves_from_species" => %{
      "name" => "burmy",
      "url" => "https=> //pokeapi.co/api/v2/pokemon-species/412/"
    },
    "evolution_chain" => %{
      "url" => "https=> //pokeapi.co/api/v2/evolution-chain/213/"
    },
    "habitat" => nil,
    "generation" => %{
      "name" => "generation-iv",
      "url" => "https=> //pokeapi.co/api/v2/generation/4/"
    },
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
    ],
    "varieties" => [
      %{
        "is_default" => true,
        "pokemon" => %{
          "name" => "wormadam-plant",
          "url" => "https=> //pokeapi.co/api/v2/pokemon/413/"
        }
      }
    ]
  }
  @valid_color %{
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

  @invalid_answer %{
    something: "invalid"
  }

  @api ShakespearePokedex.PokemonApiMock
  @subject ShakespearePokedex.PokemonManager


  describe "get_info when pokemon" do
    test "is available returns a pokemon name and a description" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @valid_species}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @valid_characteristic}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is black. Loves to eat . It can do: solar-powerblaze . It is When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs.. It can solar-powerblaze"
             }
    end

    test "is not available returns an error" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, %{}}
      end)

      assert @subject.get_info(@pokemon_name) == {:error, "invalid pokemon"}
    end

    test "is available and the rest is not it returns a pokemon name and a description" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is Unknonw.  . It can do: solar-powerblaze . It is . It can solar-powerblaze"
             }
    end
  end

  describe "get_info when color" do
    test "is available it returns a pokemon name and description with it" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is black.  . It can do: solar-powerblaze . It is . It can solar-powerblaze"
             }
    end

    test "is not available returns a pokemon name and description with unknown color" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @valid_species}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @valid_characteristic}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is Unknonw. Loves to eat . It can do: solar-powerblaze . It is When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs.. It can solar-powerblaze"
             }
    end
  end

  describe "get_info when species" do
    test "is available it returns a pokemon name and description with it" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @valid_species}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is Unknonw.  . It can do: solar-powerblaze . It is When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs.. It can solar-powerblaze"
             }
    end

    test "contains escape char it returns a pokemon name and description with it cleaned" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok,
         %{
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
           "varieties" => [
             %{
               "is_default" => true,
               "pokemon" => %{
                 "name" => "wormadam-plant",
                 "url" => "https=> //pokeapi.co/api/v2/pokemon/413/"
               }
             }
           ]
         }}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is Unknonw.  . It can do: solar-powerblaze . It is When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs.. It can solar-powerblaze"
             }
    end

    test "contains duplicated sentences it returns a pokemon name and description with it cleaned" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok,
         %{
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
           ],
           "varieties" => [
             %{
               "is_default" => true,
               "pokemon" => %{
                 "name" => "wormadam-plant",
                 "url" => "https=> //pokeapi.co/api/v2/pokemon/413/"
               }
             }
           ]
         }}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is Unknonw.  . It can do: solar-powerblaze . It is When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs.. It can solar-powerblaze"
             }
    end

    test "is not available it returns a pokemon name and description without any species" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @valid_color}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is black.  . It can do: solar-powerblaze . It is . It can solar-powerblaze"
             }
    end
  end

  describe "get_info when abilities" do
    test "is available returns a pokemon name and a description" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is Unknonw.  . It can do: solar-powerblaze . It is . It can solar-powerblaze"
             }
    end

    test "is not available returns an error" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, %{
          "name" => "charizard",
          "order" => 7,
          "species" => %{
            "name" => "charizard",
            "url" => "https =>//pokeapi.co/api/v2/pokemon-species/6/"
          },
          "id" => @pokemon_id
        }}
      end)

      assert @subject.get_info(@pokemon_name) == {:error, "invalid pokemon"}
    end
  end

  describe "get_info when description" do
    test "is available it returns a pokemon name and description with it" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @valid_characteristic}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is Unknonw. Loves to eat . It can do: solar-powerblaze . It is . It can solar-powerblaze"
             }
    end

    test "contains escape char it returns a pokemon name and description with it cleaned" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is Unknonw.  . It can do: solar-powerblaze . It is . It can solar-powerblaze"
             }
    end

    test "is not available it returns a pokemon name and description without any species" do
      expect(@api, :get_pokemon, fn @pokemon_name ->
        {:ok, @valid_pokemon_response}
      end)

      expect(@api, :get_species, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_description, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      expect(@api, :get_color, fn @pokemon_id ->
        {:ok, @invalid_answer}
      end)

      {:ok, answer} = @subject.get_info(@pokemon_name)

      assert answer == %{
               name: "testMeEasly",
               description:
                 "charizard. Its color is Unknonw.  . It can do: solar-powerblaze . It is . It can solar-powerblaze"
             }
    end
  end
end
