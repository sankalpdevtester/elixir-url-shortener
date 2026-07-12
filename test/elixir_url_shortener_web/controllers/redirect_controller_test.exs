defmodule ElixirUrlShortenerWeb.RedirectControllerTest do
  use ElixirUrlShortenerWeb.ConnCase

  alias ElixirUrlShortener.Url
  alias ElixirUrlShortener.Repo

  setup do
    url = %Url{original_url: "https://example.com", short_url: "abc123"}
    Repo.insert!(url)

    {:ok, url: url}
  end

  test "GET /redirect/:short_url redirects to original URL", %{conn: conn, url: url} do
    conn = get(conn, "/redirect/#{url.short_url}")

    assert redirected_to(conn) == url.original_url
  end

  test "GET /redirect/:short_url increments redirect count", %{conn: conn, url: url} do
    original_redirect_count = url.redirect_count

    conn = get(conn, "/redirect/#{url.short_url}")

    url = Repo.get(Url, url.id)
    assert url.redirect_count == original_redirect_count + 1
  end

  test "GET /redirect/:short_url returns 404 if URL does not exist", %{conn: conn} do
    conn = get(conn, "/redirect/non-existent-url")

    assert html_response(conn, 404) =~ "Not Found"
  end
end