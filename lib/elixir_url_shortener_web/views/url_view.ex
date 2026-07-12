defmodule ElixirUrlShortenerWeb.UrlView do
  use ElixirUrlShortenerWeb, :view

  def render("shorten.json", %{shortened_url: shortened_url}) do
    %{shortened_url: shortened_url}
  end

  def render("analytics.json", %{clicks: clicks}) do
    %{clicks: clicks}
  end
end