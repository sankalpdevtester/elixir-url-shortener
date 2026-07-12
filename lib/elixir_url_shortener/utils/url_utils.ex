defmodule ElixirUrlShortener.Utils.UrlUtils do
  @moduledoc """
  Utility module for URL validation and normalization.
  """

  @doc """
  Validates a URL by checking its scheme and host.
  """
  @spec validate_url(String.t()) :: :ok | {:error, String.t()}
  def validate_url(url) do
    case URI.parse(url) do
      %URI{scheme: nil} -> {:error, "Invalid URL: scheme is missing"}
      %URI{host: nil} -> {:error, "Invalid URL: host is missing"}
      %URI{scheme: scheme, host: host} ->
        if scheme in ["http", "https"] do
          :ok
        else
          {:error, "Invalid URL: scheme must be http or https"}
        end
    end
  end

  @doc """
  Normalizes a URL by converting it to lowercase and removing trailing slashes.
  """
  @spec normalize_url(String.t()) :: String.t()
  def normalize_url(url) do
    url
    |> String.downcase()
    |> String.trim_trailing("/")
  end

  @doc """
  Checks if a URL is already shortened.
  """
  @spec is_shortened_url?(String.t()) :: boolean()
  def is_shortened_url?(url) do
    ElixirUrlShortener.Repo.get_by(ElixirUrlShortener.Url, original_url: url) != nil
  end

  @doc """
  Generates a random shortened URL code.
  """
  @spec generate_shortened_code() :: String.t()
  def generate_shortened_code do
    :crypto.strong_rand_bytes(6)
    |> Base.url_encode64()
    |> String.replace("-", "")
    |> String.replace("_", "")
    |> String.slice(0..5)
  end
end
```
In the `lib/elixir_url_shortener_web/controllers/url_shortener_controller.ex` file, you can use the `UrlUtils` module like this:
```elixir
defmodule ElixirUrlShortenerWeb.Controllers.UrlShortenerController do
  use ElixirUrlShortenerWeb, :controller

  alias ElixirUrlShortener.Utils.UrlUtils

  def create(conn, %{"url" => url}) do
    case UrlUtils.validate_url(url) do
      :ok ->
        shortened_code = UrlUtils.generate_shortened_code()
        # Create a new shortened URL
        # ...
      {:error, error} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: error})
    end
  end
end
```
In the `lib/elixir_url_shortener_web/controllers/analytics_controller.ex` file, you can use the `UrlUtils` module like this:
```elixir
defmodule ElixirUrlShortenerWeb.Controllers.AnalyticsController do
  use ElixirUrlShortenerWeb, :controller

  alias ElixirUrlShortener.Utils.UrlUtils

  def show(conn, %{"id" => id}) do
    url = ElixirUrlShortener.Repo.get_by(ElixirUrlShortener.Url, id: id)
    if url do
      original_url = UrlUtils.normalize_url(url.original_url)
      # Get analytics data for the original URL
      # ...
    else
      conn
      |> put_status(:not_found)
      |> json(%{error: "URL not found"})
    end
  end
end