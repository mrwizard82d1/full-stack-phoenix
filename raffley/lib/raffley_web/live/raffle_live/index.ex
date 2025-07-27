defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  import RaffleyWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket = assign(socket, :raffles, Raffles.list_raffles())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <.banner :let={vibe}>
        <.icon name="hero-sparkles-solid" /> Mystery  Raffle Coming Soon! {vibe}
        <:details>
          To Be Revealed Tomorrow
        </:details>
        Larry
      </.banner>
      <div class="raffles">
        <.raffle_card :for={raffle <- @raffles} raffle={raffle} />
      </div>
    </div>
    """
  end

  slot :inner_block, required: true
  slot :details

  def banner(assigns) do
    assigns = assign(assigns, :emoji, ~w(\u{1f600} \u{1f60d} \u{1f917}) |> Enum.random())

    ~H"""
    <div class="banner">
      <h1>
        {render_slot(@inner_block, @emoji)}
      </h1>
      <div class="details">
        {render_slot(@details)}
      </div>
    </div>
    """
  end

  attr :raffle, Raffley.Raffle, required: true

  def raffle_card(assigns) do
    ~H"""
    <div class="card">
      <img src={@raffle.image_path} />
      <h2>{@raffle.prize}</h2>
      <div class="details">
        <div class="price">
          ${@raffle.ticket_price} / ticket
        </div>
        <.badge status={@raffle.status} />
      </div>
    </div>
    """
  end
end
