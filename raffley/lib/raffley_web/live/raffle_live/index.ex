defmodule RaffleyWeb.RafflesLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles

  def mount(_params, _session, socket) do
    socket = assign(socket, :raffles, Raffles.list_raffles())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <div class="raffles">
        <div :for={raffle <- @raffles} class="card">
          <h2>{raffle.prize}</h2>
        </div>
      </div>
    </div>
    """
  end
end
