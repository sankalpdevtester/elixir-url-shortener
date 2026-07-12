defmodule ElixirUrlShortenerWeb.Services.UrlAnalyticsService do
  @moduledoc """
  Service module for handling URL analytics.
  """

  alias ElixirUrlShortener.Repo
  alias ElixirUrlShortener.Url

  @doc """
  Increment the click count for a given URL.
  """
  def increment_click_count(url_id) do
    Repo.get(Url, url_id)
    |> increment_click_count()
  end

  defp increment_click_count(nil), do: {:error, :url_not_found}
  defp increment_click_count(url) do
    url
    |> Ecto.Changeset.change(click_count: url.click_count + 1)
    |> Repo.update()
  end

  @doc """
  Get the click count for a given URL.
  """
  def get_click_count(url_id) do
    Repo.get(Url, url_id)
    |> get_click_count()
  end

  defp get_click_count(nil), do: {:error, :url_not_found}
  defp get_click_count(url), do: {:ok, url.click_count}

  @doc """
  Get the top N URLs by click count.
  """
  def get_top_urls(n) do
    Repo.all(from(u in Url, order_by: [desc: u.click_count], limit: ^n))
  end

  @doc """
  Get the click count history for a given URL.
  """
  def get_click_count_history(url_id) do
    Repo.get(Url, url_id)
    |> get_click_count_history()
  end

  defp get_click_count_history(nil), do: {:error, :url_not_found}
  defp get_click_count_history(url) do
    # For simplicity, this example assumes a simple click count history
    # In a real-world application, you would likely want to store this data in a separate table
    {:ok, url.click_count_history || []}
  end
end
```
To integrate this service with the existing `AnalyticsController`, you can add the following code to `lib/elixir_url_shortener_web/controllers/analytics_controller.ex`:
```elixir
defmodule ElixirUrlShortenerWeb.AnalyticsController do
  # ...

  def get_click_count(conn, %{"url_id" => url_id}) do
    case ElixirUrlShortenerWeb.Services.UrlAnalyticsService.get_click_count(url_id) do
      {:ok, click_count} ->
        json(conn, %{click_count: click_count})

      {:error, :url_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "URL not found"})
    end
  end

  def get_top_urls(conn, %{"n" => n}) do
    top_urls = ElixirUrlShortenerWeb.Services.UrlAnalyticsService.get_top_urls(n)
    json(conn, %{top_urls: top_urls})
  end

  def get_click_count_history(conn, %{"url_id" => url_id}) do
    case ElixirUrlShortenerWeb.Services.UrlAnalyticsService.get_click_count_history(url_id) do
      {:ok, click_count_history} ->
        json(conn, %{click_count_history: click_count_history})

      {:error, :url_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "URL not found"})
    end
  end
end
```
You will also need to add routes for these new endpoints in `lib/elixir_url_shortener_web/router.ex`:
```elixir
defmodule ElixirUrlShortenerWeb.Router do
  # ...

  scope "/api", ElixirUrlShortenerWeb do
    # ...

    get "/analytics/click_count/:url_id", AnalyticsController, :get_click_count
    get "/analytics/top_urls/:n", AnalyticsController, :get_top_urls
    get "/analytics/click_count_history/:url_id", AnalyticsController, :get_click_count_history
  end
end
```
Finally, you can test these new endpoints using the existing `AnalyticsControllerTest`:
```elixir
defmodule ElixirUrlShortenerWeb.AnalyticsControllerTest do
  # ...

  test "get click count", %{conn: conn} do
    url = insert(:url)
    conn = get(conn, "/api/analytics/click_count/#{url.id}")
    assert json_response(conn, 200) == %{click_count: 0}
  end

  test "get top urls", %{conn: conn} do
    insert_list(10, :url)
    conn = get(conn, "/api/analytics/top_urls/5")
    assert json_response(conn, 200) == %{top_urls: _}
  end

  test "get click count history", %{conn: conn} do
    url = insert(:url)
    conn = get(conn, "/api/analytics/click_count_history/#{url.id}")
    assert json_response(conn, 200) == %{click_count_history: []}
  end
end