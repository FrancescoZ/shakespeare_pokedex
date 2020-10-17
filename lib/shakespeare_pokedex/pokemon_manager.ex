defmodule ShakespearePokedex.PokemonManager do
  @moduledoc """
  Retrieve the pokemon information
  """
  @api Application.get_env(:shakespeare_pokedex, :pokemon_api)
  @translator_api Application.get_env(:shakespeare_pokedex, :shakespeare_api)

  @callback get_info(name :: String.t()) :: {:ok, any} | {:error, any}

  def get_info(pokemon_name) do
    with {:ok, %{name: name, id: id, abilities: abilities}} <-
           @api.get_pokemon(pokemon_name),
         {:ok, characteristics} <-
           @api.get_description(id),
         {:ok, species} <-
           @api.get_species(id),
         {:ok, color} <-
           @api.get_color(id),
         {:ok, original_description} <-
           generate_description(name, color, abilities, characteristics, species),
         {:ok, description} <- @translator_api.translate(original_description) do
      {:ok,
       %{
         name: pokemon_name,
         description: description
       }}
    else
      {:error, error} ->
        {:error, error}

      _ ->
        {:error, "undefined_error"}
    end
  end

  defp generate_description(name, color, abilities, characteristics, species) do
    {:ok,
     "#{name}. Its color is #{color}.#{
       Enum.reduce(characteristics, "", fn x, acc -> x <> acc end)
     }. It can do: #{Enum.reduce(abilities, "", fn x, acc -> x <> acc end)}.#{
       Enum.reduce(species, "", fn x, acc -> x <> acc end)
     }."}
  end
end
