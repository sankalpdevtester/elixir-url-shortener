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
