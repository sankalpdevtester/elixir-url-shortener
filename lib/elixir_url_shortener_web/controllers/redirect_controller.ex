defmodule ElixirUrlShortenerWeb.RedirectController do
  use ElixirUrlShortenerWeb, :controller

  alias ElixirUrlShortener.Url
  alias ElixirUrlShortener.Repo

  def show(conn, %{"short_url" => short_url}) do
    case Url.get_by_short_url(short_url) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("404.html")

      url ->
        url
        |> Url.increment_redirect_count()
        |> Repo.update()

        redirect(conn, external: url.original_url)
    end
  end

  defp increment_redirect_count(url) do
    url
    |> Ecto.Changeset.change(redirect_count: url.redirect_count + 1)
  end
end