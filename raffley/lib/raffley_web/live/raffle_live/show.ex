defmodule RaffleyWeb.RaffleLive.Show do
  use RaffleyWeb, :live_view

  def mount(params, _session, socket) do
    raise inspect(params, title: "params")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-show">
      Details
    </div>
    """
  end
end
