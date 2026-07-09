defmodule ElixirUrlShortenerWeb.UrlShortenerController do
  use ElixirUrlShortenerWeb, :controller

  alias ElixirUrlShortener.UrlShortener

  def shorten(conn, %{"url" => url}) do
    case UrlShortener.shorten(url) do
      {:ok, short_url} ->
        json(conn, %{short_url: short_url})

      {:error, reason} ->
        json(conn, %{error: reason})
    end
  end

  def redirect(conn, %{"short_url" => short_url}) do
    case UrlShortener.redirect(short_url) do
      {:ok, original_url} ->
        redirect(conn, external: original_url)

      {:error, reason} ->
        json(conn, %{error: reason})
    end
  end
end