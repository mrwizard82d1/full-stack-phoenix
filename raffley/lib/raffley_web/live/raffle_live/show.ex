defmodule RaffleyWeb.RaffleLive.Show do
  use RaffleyWeb, :live_view

  def mount(_params, _session, socket) do
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
