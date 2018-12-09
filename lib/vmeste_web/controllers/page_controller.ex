defmodule VmesteWeb.PageController do
  use VmesteWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
