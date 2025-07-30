defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  # A LiveView module defines three primary callback functions
  # `mount`
  # `render`
  # `handel_event`

  def mount(_params, _session, socket) do
    if connected?(socket) do
      # Send a message after 2 seconds - but only if we are connected
      Process.send_after(self(), :tick, 2000)
    end

    # Assigns two pieces of "state" for our "socket"
    socket = assign(socket, tickets: 0, price: 3, page_title: "Estimator")

    IO.inspect(self(), label: "mount")

    # Most often return a two-item tuple
    # But we can options such as the HTML `layout` to apply
    # {:ok, socket, layout: {RaffleyWeb.Layouts, :simple}}
    {:ok, socket}

    # Note that the return value of `socket` is often inlined "in the wild"
    # {:ok, assign(socket, tickets: 0, price: 3)}
  end

  def render(assigns) do
    IO.inspect(self(), label: "render")

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

      <form phx-submit="set-price">
        <label>Ticket Price:</label>
        <input type="number" name="price" value={@price} />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    IO.inspect(self(), label: "handle_event/3 (add)")

    # Update the socket by incremementing the number of tickets "sold"
    socket = update(socket, :tickets, &(&1 + String.to_integer(quantity)))

    IO.inspect(socket)

    {:noreply, socket}
  end

  def handle_event("set-price", %{"price" => price}, socket) do
    IO.inspect(self(), label: "handle_event/3 (set-price)")

    # Assign a new value to the socket by converting the String price to an integer
    socket = assign(socket, :price, String.to_integer(price))

    IO.inspect(socket)

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    # Schedule the next regular `:tick` message
    Process.send_after(self(), :tick, 2000)
    {:noreply, update(socket, :tickets, &(&1 + 10))}
  end
end
