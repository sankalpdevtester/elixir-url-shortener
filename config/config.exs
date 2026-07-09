import Config

# Configure Phoenix
config :phoenix, :json_library, Jason

# Configure the endpoint
config :elixir_url_shortener, ElixirUrlShortenerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ElixirUrlShortenerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ElixirUrlShortener.PubSub,
  live_view: [signing_salt: "your_signing_salt"]

# Configure the repository
config :elixir_url_shortener, ElixirUrlShortener.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "elixir_url_shortener_dev",
  hostname: "localhost",
  pool_size: 10

# Configure the ecto repository for production
config :elixir_url_shortener, ElixirUrlShortener.Repo, pool: Ecto.Adapters.SQL.Sandbox

# Import environment specific config. This must remain at the bottom
# of this file to merge it with the module configuration defined above.
import_config "#{Mix.env()}.exs"