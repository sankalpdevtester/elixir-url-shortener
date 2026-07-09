defmodule ElixirUrlShortener.Application do
  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ElixirUrlShortener.Repo,
      # Start the Telemetry supervisor
      ElixirUrlShortenerWeb.Telemetry,
      # Start the Phoenix PubSub system
      {Phoenix.PubSub, name: ElixirUrlShortener.PubSub},
      # Start the Endpoint (http/https)
      ElixirUrlShortenerWeb.Endpoint
      # Start a worker by calling: ElixirUrlShortener.Worker.start_link(arg)
      # {ElixirUrlShortener.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirUrlShortener.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixirUrlShortenerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end