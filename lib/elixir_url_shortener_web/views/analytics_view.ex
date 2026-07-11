defmodule ElixirUrlShortenerWeb.AnalyticsView do
  use ElixirUrlShortenerWeb, :view

  def render("index.json", %{analytics: analytics}) do
    %{
      clicks: analytics.clicks,
      referrers: analytics.referrers,
      browsers: analytics.browsers,
      platforms: analytics.platforms
    }
  end

  def render("created.json", _assigns) do
    %{message: "URL analytics updated successfully"}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end