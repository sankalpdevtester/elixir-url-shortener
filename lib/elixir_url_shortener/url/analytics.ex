defmodule ElixirUrlShortener.Url.Analytics do
  alias ElixirUrlShortener.Repo
  alias ElixirUrlShortener.Url

  def get_analytics(url_id) do
    Repo.all(from(u in Url, where: u.id == ^url_id, select: %{
      clicks: count(u.id),
      referrers: fragment("ARRAY_AGG(DISTINCT ?)", u.referrer),
      browsers: fragment("ARRAY_AGG(DISTINCT ?)", u.browser),
      platforms: fragment("ARRAY_AGG(DISTINCT ?)", u.platform)
    }))
  end

  def update_analytics(url_id, referrer, browser, platform) do
    url = Repo.get(Url, url_id)

    if url do
      changeset = Url.changeset(url, %{referrer: referrer, browser: browser, platform: platform})

      case Repo.update(changeset) do
        {:ok, _url} ->
          :ok

        {:error, _changeset} ->
          {:error, "Failed to update URL analytics"}
      end
    else
      {:error, "URL not found"}
    end
  end
end