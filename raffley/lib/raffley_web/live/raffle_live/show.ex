defmodule RaffleyWeb.RaffleLive.Show do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  import RaffleyWeb.CustomComponents

  def mount(%{"id" => id}, _session, socket) do
    raffle = Raffles.get_raffle(id)

    socket =
      socket
      |> assign(:raffle, raffle)
      |> assign(:page_title, raffle.prize)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-show">
      Details for raffle {inspect(@raffle)}
    </div>
    """
  end
end
