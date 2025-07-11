defmodule HeadsUpWeb.TipController do
 use HeadsUpWeb, :controller

  def index(conn, _args) do
    tips = Tips.list_tips()

    render(conn, :index, tips: tips)
  end
end
