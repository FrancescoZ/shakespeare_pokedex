defmodule ShakespearePokedex.PokemonManager do
  @moduledoc """
  Retrieve the pokemon information
  """
  @api Application.get_env(:shakespeare_pokedex, :pokemon_api)

  @callback get_info(name :: String.t()) :: {:ok, any} | {:error, any}

  def get_info(pokemon_name) do
    with {:ok, %{name: name, id: id, abilities: abilities}} <-
           @api.get_pokemon(pokemon_name)
           |> get_pokemon(),
         {:ok, characteristics} <-
           @api.get_description(id)
           |> get_description(),
         {:ok, species} <-
           @api.get_species(id)
           |> get_species(),
         {:ok, color} <-
           @api.get_color(id)
           |> get_color() do
      {:ok,
       %{
         name: pokemon_name,
         description:
           "#{name}. Its color is #{color}. #{
             Enum.reduce(characteristics, "", fn x, acc -> x <> acc end)
           } . It can do: #{Enum.reduce(abilities, "", fn x, acc -> x <> acc end)} . It is #{
             Enum.reduce(species, "", fn x, acc -> x <> acc end)
           }. It can #{Enum.reduce(abilities, "", fn x, acc -> x <> acc end)}"
       }}
    else
      {:error, error} ->
        {:error, error}

      _ ->
        {:error, "undefined_error"}
    end
  end

  defp get_pokemon({:ok, %{"name" => name, "id" => id, "abilities" => moves}}) do
    abilities = moves |> Enum.map(fn %{"ability" => %{"name" => name}} -> name end)
    {:ok, %{name: name, id: id, abilities: abilities}}
  end

  defp get_pokemon(_response), do: {:error, "invalid pokemon"}

  defp get_description({:ok, %{"descriptions" => descriptions}}) do
    characteristics =
      descriptions
      |> Enum.filter(fn %{"language" => %{"name" => language}} ->
        language == "en"
      end)
      |> Enum.map(fn %{"description" => description, "language" => %{"name" => "en"}} ->
        description
        |> String.replace(~r/\\[a-z]/, " ")
      end)

    {:ok, characteristics}
  end

  defp get_description(_response), do: {:ok, []}

  defp get_species({:ok, %{"flavor_text_entries" => flavors}}) do
    species =
      flavors
      |> Enum.filter(fn %{"language" => %{"name" => language}} ->
        language == "en"
      end)
      |> Enum.map(fn %{"flavor_text" => description, "language" => %{"name" => "en"}} ->
        description
        |> String.replace(["\n", "\f", "\e"], " ")
      end)

    {:ok, Enum.uniq(species)}
  end

  defp get_species(_response), do: {:ok, []}

  defp get_color({:ok, %{"name" => color}}), do: {:ok, color}
  defp get_color(_response), do: {:ok, "Unknonw"}
end
