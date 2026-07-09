defmodule ElixirUrlShortenerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :elixir_url_shortener

  plug Phoenix.LiveDashboard.RequestLogger,
    path: "/phoenix/live_dashboard/request_logger",
    pipeline: :browser

  plug :root_check

  plug :session, [
    store: :cookie,
    key: "_elixir_url_shortener_key",
    signing_salt: "your_signing_salt"
  ]

  socket "/phoenix/live", Phoenix.LiveView.Socket

  # Serve at "/" the static files from "priv/static" directory
  #
  # You should set gzip: true to enable gzipping but it requires a more
  # advanced cache control strategy. Defining a cache control strategy
  # without gzipping will not work as expected without configuration of
  # the gzip module.
  plug Plug.Static,
    at: "/",
    from: :elixir_url_shortener,
    gzip: false,
    only: ~w(css fonts images favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # ":code_reloading" configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :elixir_url_shortener
  end

  plug Phoenix.LiveReload,
    otp_app: :elixir_url_shortener,
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po|pot)$",
      ~r"lib/elixir_url_shortener/{web,vue,js}/.*(ex|exs|eex|leex|heex)$",
      ~r"lib/elixir_url_shortener/templates/.*(eex|leex|heex)$"
    ]

  # The session will be stored in the cookie and signed,
  # this means its contents can be safely stored clientside
  plug Plug.Session, @session_options

  # Enable JSON encoding
  plug Jason

  # Enable CORS (Cross Origin Resource Sharing) for API requests
  # This is just an example, please set your own CORS policy
  plug CORSPlug

  # Load endpoints
  forward "/api", ElixirUrlShortenerWeb.Router

  # Catch all unmatched routes
  plug :not_found
end