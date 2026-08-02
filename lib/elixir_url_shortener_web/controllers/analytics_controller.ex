defmodule ElixirUrlShortenerWeb.AnalyticsController do
  use ElixirUrlShortenerWeb, :controller

  alias ElixirUrlShortener.Repo
  alias ElixirUrlShortener.Url.Analytics
  alias ElixirUrlShortener.Web.Services.UrlAnalyticsService

  def index(conn, _params) do
    analytics = UrlAnalyticsService.get_all_analytics()
    render(conn, "index.json", analytics: analytics)
  end

  def show(conn, %{"id" => id}) do
    analytics = UrlAnalyticsService.get_analytics_by_id(id)
    case analytics do
      nil -> send_resp(conn, 404, "Not Found")
      _ -> render(conn, "show.json", analytics: analytics)
    end
  end

  def create(conn, %{"url_id" => url_id}) do
    case UrlAnalyticsService.create_analytics(url_id) do
      {:ok, analytics} -> render(conn, "show.json", analytics: analytics)
      {:error, changeset} -> send_resp(conn, 400, "Invalid request")
    end
  end

  def update(conn, %{"id" => id, "clicks" => clicks}) do
    case UrlAnalyticsService.update_analytics(id, clicks) do
      {:ok, analytics} -> render(conn, "show.json", analytics: analytics)
      {:error, changeset} -> send_resp(conn, 400, "Invalid request")
    end
  end

  def delete(conn, %{"id" => id}) do
    case UrlAnalyticsService.delete_analytics(id) do
      {:ok, _} -> send_resp(conn, 204, "No Content")
      {:error, _} -> send_resp(conn, 404, "Not Found")
    end
  end
end
```
We also need to add routes for the new controller in `lib/elixir_url_shortener_web/router.ex`:
```elixir
defmodule ElixirUrlShortenerWeb.Router do
  use ElixirUrlShortenerWeb, :router

  # ...

  scope "/api", ElixirUrlShortenerWeb do
    pipe_through :api

    resources "/analytics", AnalyticsController
  end

  # ...
end
```
And add a view for the new controller in `lib/elixir_url_shortener_web/views/analytics_view.ex`:
```elixir
defmodule ElixirUrlShortenerWeb.AnalyticsView do
  use ElixirUrlShortenerWeb, :view

  def render("index.json", %{analytics: analytics}) do
    %{data: Enum.map(analytics, &render_one(&1, "analytics.json"))}
  end

  def render("show.json", %{analytics: analytics}) do
    render_one(analytics, "analytics.json")
  end

  def render("analytics.json", %{analytics: analytics}) do
    %{
      id: analytics.id,
      url_id: analytics.url_id,
      clicks: analytics.clicks
    }
  end
end
```
And finally, we need to add a migration to create the analytics table in `priv/repo/migrations/20230220144424_create_analytics.exs`:
```elixir
defmodule ElixirUrlShortener.Repo.Migrations.CreateAnalytics do
  use Ecto.Migration

  def change do
    create table(:analytics) do
      add :url_id, references(:urls, on_delete: :delete_all)
      add :clicks, :integer, default: 0

      timestamps()
    end
  end
end