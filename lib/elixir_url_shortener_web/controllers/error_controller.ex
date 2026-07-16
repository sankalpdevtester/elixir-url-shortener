defmodule ElixirUrlShortenerWeb.ErrorController do
  use ElixirUrlShortenerWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    render(conn, "error.html", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render("404.html")
  end

  def call(conn, {:error, :internal_server_error}) do
    conn
    |> put_status(:internal_server_error)
    |> render("500.html")
  end

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> render("400.html")
  end
end