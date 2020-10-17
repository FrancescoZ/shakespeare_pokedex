defmodule ShakespearePokedex.ShakespeareApi do
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

  @callback translate(text :: String.t()) :: {:ok, any} | {:error, any}

  def translate(text),
    do:
      "shakespeare"
      |> post(%{text: text})
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

  defp base_url(), do: Application.get_env(:shakespeare_pokedex, :shakespeare_api_url)
end
