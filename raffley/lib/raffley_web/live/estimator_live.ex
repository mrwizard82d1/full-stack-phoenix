defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  # A LiveView module defines three primary callback functions
  # `mount`
  # `render`
  # `handel_event`

  def mount(_params, _session, socket) do
    # Assigns two pieces of "state" for our "socket"
    socket = assign(socket, tickets: 0, price: 3)

    IO.inspect(socket)

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

      <button phx-click="add" phx-value-quantity="5">
        +
      </button>

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

  def handle_event("add", %{"quantity" => quantity}, socket) do
    # Update the socket by incremementing the number of tickets "sold"
    socket = update(socket, :tickets, &(&1 + String.to_integer(quantity)))

    IO.inspect(socket)

    {:noreply, socket}
  end
end
