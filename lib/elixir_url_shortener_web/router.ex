defmodule ElixirUrlShortenerWeb.Router do
  use ElixirUrlShortenerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElixirUrlShortenerWeb do
    pipe_through :api

    post "/shorten", UrlShortenerController, :shorten
    get "/:short_url", UrlShortenerController, :redirect
  end
end