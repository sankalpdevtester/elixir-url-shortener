defmodule ElixirUrlShortenerWeb.RedirectView do
  use ElixirUrlShortenerWeb, :view

  def render("404.html", _assigns) do
    """
    <html>
      <body>
        <h1>Not Found</h1>
        <p>The URL you are looking for does not exist.</p>
      </body>
    </html>
    """
  end
end