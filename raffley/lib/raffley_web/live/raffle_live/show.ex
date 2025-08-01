defmodule RaffleyWeb.RaffleLive.Show do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles

  def mount(%{"id" => id}, _session, socket) do
    raffle = Raffles.get_raffle(id)

    socket =
      socket
      |> assign(:raffle, raffle)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-show">
      Details for raffle {@raffle}
    </div>
    """
  end
end
