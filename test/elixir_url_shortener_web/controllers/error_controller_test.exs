defmodule ElixirUrlShortenerWeb.ErrorControllerTest do
  use ElixirUrlShortenerWeb.ConnCase

  describe "call/2" do
    test "renders error.html with changeset" do
      changeset = Ecto.Changeset.cast(%{}, %{}, [])
      conn = get(build_conn(), "/error", error: {:error, changeset})
      assert html_response(conn, 200) =~ "Error"
    end

    test "renders 404.html with not_found error" do
      conn = get(build_conn(), "/error", error: {:error, :not_found})
      assert html_response(conn, 404) =~ "Page not found"
    end

    test "renders 500.html with internal_server_error" do
      conn = get(build_conn(), "/error", error: {:error, :internal_server_error})
      assert html_response(conn, 500) =~ "Internal server error"
    end

    test "renders 400.html with bad_request error" do
      conn = get(build_conn(), "/error", error: {:error, :bad_request})
      assert html_response(conn, 400) =~ "Bad request"
    end
  end
end