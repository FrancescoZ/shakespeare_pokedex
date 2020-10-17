defmodule ShakespearePokedex.PokemonApi do
  use Tesla

  @gateway_timeout Application.get_env(:shakespeare_pokedex, :gateway_timeout)
  @fuse_options Application.get_env(:shakespeare_pokedex, :fuse_options)

  plug Tesla.Middleware.BaseUrl, base_url()
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Timeout, timeout: @gateway_timeout

  plug Tesla.Middleware.Fuse,
    opts: @fuse_options,
    keep_original_error: false,
    should_melt: fn
      {:ok, %{status: status}} when status > 499 -> true
      {:ok, _} -> false
      {:error, _} -> true
    end

  @callback get_pokemon(name :: String.t()) :: {:ok, any} | {:error, any}
  @callback get_description(name :: String.t()) :: {:ok, any} | {:error, any}
  @callback get_species(name :: String.t()) :: {:ok, any} | {:error, any}
  @callback get_color(name :: String.t()) :: {:ok, any} | {:error, any}

  def get_pokemon(pokemon_name),
    do:
      "/pokemon/#{pokemon_name}"
      |> get()
      |> handle_response()

  def get_description(pokemon_id),
    do:
      "/characteristic/#{pokemon_id}"
      |> get()
      |> handle_response()

  def get_species(pokemon_id),
    do:
      "/pokemon-species/#{pokemon_id}"
      |> get()
      |> handle_response()

  def get_color(pokemon_id),
    do:
      "/pokemon-color/#{pokemon_id}"
      |> get()
      |> handle_response()

  defp handle_response({
         :ok,
         %Tesla.Env{
           body: body,
           status: 200
         }
       }) do
    {:ok, body}
  end

  defp handle_response({:ok, %Tesla.Env{status: status}}) when status in 500..599,
    do: {:error, "server_error"}

  defp handle_response({:ok, %Tesla.Env{status: status}}) when status in 400..499,
    do: {:error, "client_error"}

  defp handle_response({:error, {Tesla.Middleware.JSON, :decode, _error}}),
    do: {:error, "invalid_payload"}

  defp handle_response({:error, :timeout}), do: {:error, "timeout"}
  defp handle_response({:error, :unavailable}), do: {:error, "circuit_open"}
  defp handle_response(_response), do: {:error, "Generic error"}

  defp base_url(), do: Application.get_env(:shakespeare_pokedex, :pokemon_api_url)
end
