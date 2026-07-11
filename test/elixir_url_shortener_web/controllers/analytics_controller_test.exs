defmodule ElixirUrlShortenerWeb.AnalyticsControllerTest do
  use ElixirUrlShortenerWeb.ConnCase

  alias ElixirUrlShortener.Url
  alias ElixirUrlShortener.Repo

  setup do
    url = Repo.insert!(%Url{short_url: "test", original_url: "https://example.com"})

    {:ok, url: url}
  end

  test "GET /analytics", %{conn: conn, url: url} do
    conn = get(conn, "/analytics?short_url=#{url.short_url}")

    assert json_response(conn, 200) == %{
             "clicks" => 0,
             "referrers" => [],
             "browsers" => [],
             "platforms" => []
           }
  end

  test "POST /analytics", %{conn: conn, url: url} do
    conn = post(conn, "/analytics", %{
      "short_url" => url.short_url,
      "referrer" => "https://example.com",
      "browser" => "Chrome",
      "platform" => "Windows"
    })

    assert json_response(conn, 201) == %{"message" => "URL analytics updated successfully"}
  end

  test "GET /analytics with invalid short URL", %{conn: conn} do
    conn = get(conn, "/analytics?short_url=invalid")

    assert json_response(conn, 404) == %{"error" => "URL not found"}
  end

  test "POST /analytics with invalid short URL", %{conn: conn} do
    conn = post(conn, "/analytics", %{
      "short_url" => "invalid",
      "referrer" => "https://example.com",
      "browser" => "Chrome",
      "platform" => "Windows"
    })

    assert json_response(conn, 404) == %{"error" => "URL not found"}
  end
end