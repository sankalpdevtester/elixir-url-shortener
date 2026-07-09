defmodule ElixirUrlShortener.UrlShortener do
  alias ElixirUrlShortener.Repo
  alias ElixirUrlShortener.Url

  def shorten(url) do
    case Repo.get_by(Url, original_url: url) do
      nil ->
        short_url = generate_short_url()
        Repo.insert(%Url{original_url: url, short_url: short_url})

      url ->
        {:ok, url.short_url}
    end
  end

  def redirect(short_url) do
    case Repo.get_by(Url, short_url: short_url) do
      nil ->
        {:error, "Short URL not found"}

      url ->
        {:ok, url.original_url}
    end
  end

  defp generate_short_url do
    # Generate a random short URL
    # This is a very basic implementation and should be replaced with a more secure one
    "http://example.com/" <> Enum.random(1..1000000) |> to_string()
  end
end