defmodule ElixirUrlShortenerWeb.UrlController do
  use ElixirUrlShortenerWeb, :controller

  alias ElixirUrlShortener.UrlShortener
  alias ElixirUrlShortener.Url

  def shorten(conn, %{"url" => url}) do
    case UrlShortener.shorten_url(url) do
      {:ok, shortened_url} ->
        json(conn, %{shortened_url: shortened_url})

      {:error, reason} ->
        json(conn, %{error: reason}, status: 400)
    end
  end

  def redirect(conn, %{"shortened_url" => shortened_url}) do
    case UrlShortener.get_original_url(shortened_url) do
      {:ok, original_url} ->
        redirect(conn, external: original_url)

      {:error, reason} ->
        json(conn, %{error: reason}, status: 404)
    end
  end

  def analytics(conn, %{"shortened_url" => shortened_url}) do
    case UrlShortener.get_url_analytics(shortened_url) do
      {:ok, analytics} ->
        json(conn, analytics)

      {:error, reason} ->
        json(conn, %{error: reason}, status: 404)
    end
  end
end