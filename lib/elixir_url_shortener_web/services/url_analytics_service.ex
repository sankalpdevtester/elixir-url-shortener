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
