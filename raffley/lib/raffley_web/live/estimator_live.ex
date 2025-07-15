defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  # A LiveView module defines three primary callback functions
  # `mount`
  # `render`
  # `handel_event`

  def mount(_params, _session, socket) do
    # Assigns two pieces of "state" for our "socket"
    socket = assign(socket, tickets: 0, price: 3)

    # Must return a two-item tuple
    {:ok, socket}

    # Note that the return value of `socket` is often inlined "in the wild"
    # {:ok, assign(socket, tickets: 0, price: 3)}
  end

  def render(assigns) do
    # Returns a HEEx template
    # Here, we use the inline sigil
    ~H"""
    <div class="estimator">
      <h1>Raffle Estimator</h1>

      <section>
        <div>
          {@tickets}
        </div>
        @
        <div>
          {@price}
        </div>
        =
        <div>
          ${@tickets * @price}
        </div>
      </section>
    </div>
    """
  end
end
