defmodule PageLiveTest do
  use SurfacePlaygroundWeb.ConnCase

  import Phoenix.LiveViewTest

  test "sanity check", %{conn: conn} do
    {:ok, _view, _html} = live(conn, "/hello")
  end
end
