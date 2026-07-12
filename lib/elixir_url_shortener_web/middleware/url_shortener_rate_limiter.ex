defmodule ElixirUrlShortenerWeb.Middleware.UrlShortenerRateLimiter do
  @moduledoc """
  Rate limiter middleware to prevent abuse of URL shortener service.
  """

  @max_requests 10
  @time_window 60 # seconds

  def init(options), do: options

  def call(conn, options) do
    ip_address = conn.remote_ip
    current_time = :os.system_time(:seconds)

    # Get the current request count for the IP address
    request_count = get_request_count(ip_address)

    # If the request count is greater than the max allowed, return an error response
    if request_count >= @max_requests do
      conn
      |> put_status(429)
      |> put_resp_header("Retry-After", "60")
      |> json(%{error: "Rate limit exceeded"})
    else
      # Otherwise, increment the request count and store it in the cache
      increment_request_count(ip_address, current_time)

      # Call the next middleware in the pipeline
      ElixirUrlShortenerWeb.Endpoint.call(conn, options)
    end
  end

  defp get_request_count(ip_address) do
    # Get the current request count from the cache
    case Cachex.get(:url_shortener_cache, ip_address) do
      {:ok, nil} -> 0
      {:ok, request_count} -> request_count
    end
  end

  defp increment_request_count(ip_address, current_time) do
    # Get the current request count from the cache
    case Cachex.get(:url_shortener_cache, ip_address) do
      {:ok, nil} ->
        # If there is no existing request count, set it to 1
        Cachex.put(:url_shortener_cache, ip_address, 1, ttl: @time_window)

      {:ok, request_count} ->
        # Otherwise, increment the request count and store it in the cache
        Cachex.put(:url_shortener_cache, ip_address, request_count + 1, ttl: @time_window)
    end
  end
end
```
In the `lib/elixir_url_shortener_web/endpoint.ex` file, add the following line to the `plug` block:
```elixir
plug ElixirUrlShortenerWeb.Middleware.UrlShortenerRateLimiter
```
This will apply the rate limiter middleware to all incoming requests.

In the `config/config.exs` file, add the following configuration for the Cachex cache:
```elixir
config :cachex,
  caches: [
    url_shortener_cache: [
      expiration: :timer.seconds(60),
      stats: true
    ]
  ]
```
This will configure the Cachex cache to store the request counts for each IP address with a TTL of 60 seconds.