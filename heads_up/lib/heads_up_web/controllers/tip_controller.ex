defmodule HeadsUpWeb.TipController do
  use HeadsUpWeb, :controller

  def index(conn, _args) do
    tips = Tips.list_tips()

    render(conn, :index, tips: tips)
  end

  def show(conn, %{"id" => id}) do
    tip = Tips.get_tip(id)
    render(conn, :show, tip: tip)
  end
end
