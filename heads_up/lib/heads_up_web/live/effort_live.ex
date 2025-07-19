defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    # Automagically add 3 responders every two seconds
    Process.send_after(self(), :tick, 2000)

    IO.inspect(self(), label: "mount/3")

    {:ok, assign(socket, responders: 0, minutes_per_responder: 10)}
  end

  def render(assigns) do
    ~H"""
    <div class="effort">
      <h1>Community Love</h1>
      <button phx-click="add" , phx-value-number="3">
        + 3
      </button>
      <section>
        <div>
          {@responders}
        </div>
        &times;
        <div>
          {@minutes_per_responder} minutes
        </div>
        =
        <div>
          {@responders * @minutes_per_responder} minutes
        </div>
      </section>

      <form phx-submit="recalculate">
        <label>Minutes Per Responder:</label>
        <input type="number" name="minutes" value={@minutes_per_responder} />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"number" => number}, socket) do
    socket = update(socket, :responders, &(&1 + String.to_integer(number)))

    {:noreply, socket}
  end

  def handle_event("recalculate", %{"minutes" => minutes}, socket) do
    socket = assign(socket, :minutes_per_responder, String.to_integer(minutes))

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 2000)

    {:noreply, update(socket, :responders, &(&1 + 3))}
  end
end
