defmodule HeadsUpWeb.TipController do
 use HeadsUpWeb, :controller

  def index(conn, _args) do
    render(conn, :index)
  end
end
