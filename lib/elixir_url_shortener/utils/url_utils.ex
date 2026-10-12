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
