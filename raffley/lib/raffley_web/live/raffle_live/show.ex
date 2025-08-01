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
      <div class="raffle">
        <img src={@raffle.image_path} />
        <section>
          <.badge status={@raffle.status} />
          <h2>
            {@raffle.prize}
          </h2>
          <div class="price">
            ${@raffle.ticket_price} / ticket
          </div>
          <div class="description">
            {@raffle.description}
          </div>
        </section>
      </div>
    </div>
    """
  end
end
