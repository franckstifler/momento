defmodule MomentoWeb.PageController do
  use MomentoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
