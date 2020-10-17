defmodule ShakespearePokedex.ShakespeareApiTest do
  use ExUnit.Case, async: true
  import Mox

  setup :verify_on_exit!

  @text "testME to be traducesdds"
  @parameter Jason.encode!(%{text: @text})

  @url Application.get_env(:shakespeare_pokedex, :shakespeare_api_url)
  @get_translate_url "#{@url}shakespeare"

  @http_client Application.get_env(:tesla, :adapter)

  @subject ShakespearePokedex.ShakespeareApi

  @valid_response %{
    "success" => %{
      "total" => 1
    },
    "contents" => %{
      "translated" =>
        "Thee did giveth mr. Tim a hearty meal,  but unfortunately what he did doth englut did maketh him kicketh the bucket.",
      "text" => "You gave Mr. Tim a hearty meal, but unfortunately what he ate made him die.",
      "translation" => "shakespeare"
    }
  }

  setup do
    :fuse.reset(@subject)
    :ok
  end

  describe "translate/1" do
    test "returns a correct value" do
      expect(@http_client, :call, fn %{
                                       method: :post,
                                       url: @get_translate_url,
                                       body: @parameter
                                     },
                                     _opts ->
        {:ok, %Tesla.Env{status: 200, body: @valid_response}}
      end)

      {:ok, result} = @subject.translate(@text)

      assert result == @valid_response
    end

    test "returns a known error" do
      expect(@http_client, :call, fn %{
                                       method: :post,
                                       url: @get_translate_url,
                                       body: @parameter
                                     },
                                     _opts ->
        {:error, :unavailable}
      end)

      assert {:error, _} = @subject.translate(@text)
    end

    test "returns an unknown error" do
      expect(@http_client, :call, fn %{
                                       method: :post,
                                       url: @get_translate_url,
                                       body: @parameter
                                     },
                                     _opts ->
        {:error, "stange error generated"}
      end)

      assert {:error, _} = @subject.translate(@text)
    end

    test "returns a 400" do
      expect(@http_client, :call, fn %{
                                       method: :post,
                                       url: @get_translate_url,
                                       body: @parameter
                                     },
                                     _opts ->
        {:ok, %Tesla.Env{status: 400, body: "Random 400 error"}}
      end)

      assert {:error, "client_error"} == @subject.translate(@text)
    end

    test "returns a 500" do
      expect(@http_client, :call, fn %{
                                       method: :post,
                                       url: @get_translate_url,
                                       body: @parameter
                                     },
                                     _opts ->
        {:ok, %Tesla.Env{status: 500}}
      end)

      assert {:error, _} = @subject.translate(@text)
    end

    test "returns a 300" do
      expect(@http_client, :call, fn %{
                                       method: :post,
                                       url: @get_translate_url,
                                       body: @parameter
                                     },
                                     _opts ->
        {:ok, %Tesla.Env{status: 300, body: "Random 300 error"}}
      end)

      assert {:error, "Generic error"} ==
               @subject.translate(@text)
    end
  end
end
