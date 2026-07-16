defmodule ElixirUrlShortenerWeb.ErrorView do
  use ElixirUrlShortenerWeb, :view

  def render("error.html", assigns) do
    %{
      changeset: assigns[:changeset]
    }
    |> Map.put(:errors, extract_errors(assigns[:changeset]))
    |> Phoenix.View.render(__MODULE__, "error.json")
  end

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render("400.html", _assigns) do
    "Bad request"
  end

  defp extract_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end