defmodule ElixirUrlShortenerWeb.AnalyticsController do
  use ElixirUrlShortenerWeb, :controller

  alias ElixirUrlShortener.Url
  alias ElixirUrlShortener.Repo

  def index(conn, %{"short_url" => short_url}) do
    url = Repo.get_by(Url, short_url: short_url)

    if url do
      analytics = Repo.all(from(u in Url, where: u.id == ^url.id, select: %{
        clicks: count(u.id),
        referrers: fragment("ARRAY_AGG(DISTINCT ?)", u.referrer),
        browsers: fragment("ARRAY_AGG(DISTINCT ?)", u.browser),
        platforms: fragment("ARRAY_AGG(DISTINCT ?)", u.platform)
      }))

      render(conn, "index.json", analytics: analytics)
    else
      conn
      |> put_status(:not_found)
      |> render("error.json", error: "URL not found")
    end
  end

  def create(conn, %{"short_url" => short_url, "referrer" => referrer, "browser" => browser, "platform" => platform}) do
    url = Repo.get_by(Url, short_url: short_url)

    if url do
      changeset = Url.changeset(url, %{referrer: referrer, browser: browser, platform: platform})

      case Repo.update(changeset) do
        {:ok, _url} ->
          conn
          |> put_status(:created)
          |> render("created.json")

        {:error, _changeset} ->
          conn
          |> put_status(:internal_server_error)
          |> render("error.json", error: "Failed to update URL")
      end
    else
      conn
      |> put_status(:not_found)
      |> render("error.json", error: "URL not found")
    end
  end
end