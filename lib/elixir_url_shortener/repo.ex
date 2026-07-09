defmodule ElixirUrlShortener.Repo do
  use Ecto.Repo,
    otp_app: :elixir_url_shortener,
    adapter: Ecto.Adapters.Postgres

  use Ecto.Query, repo: __MODULE__

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
  end
end