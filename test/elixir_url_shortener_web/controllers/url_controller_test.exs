defmodule ElixirUrlShortenerWeb.UrlControllerTest do
  use ElixirUrlShortenerWeb.ConnCase

  alias ElixirUrlShortener.Url
  alias ElixirUrlShortener.Repo

  setup do
    # Create a test URL
    url = Repo.insert!(%Url{original_url: "https://example.com", shortened_url: "http://example.com/abc123"})

    {:ok, url: url}
  end

  test "shorten/2 returns a shortened URL", %{conn: conn} do
    url = "https://example.com"
    conn = post(conn, url_path(conn, :shorten), url: url)
    assert json_response(conn, 200)["shortened_url"] =~ "http://example.com/"
  end

  test "redirect/2 redirects to the original URL", %{conn: conn, url: url} do
    conn = get(conn, url_path(conn, :redirect, shortened_url: url.shortened_url))
    assert redirected_to(conn) == url.original_url
  end

  test "analytics/2 returns the URL analytics", %{conn: conn, url: url} do
    conn = get(conn, url_path(conn, :analytics, shortened_url: url.shortened_url))
    assert json_response(conn, 200) == %{clicks: 0}
  end
end