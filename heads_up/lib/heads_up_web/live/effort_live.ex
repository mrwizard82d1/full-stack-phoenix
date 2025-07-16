defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
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
    </div>
    """
  end

  def handle_event("add", %{"number" => number}, socket) do
    socket = update(socket, :responders, &(&1 + String.to_integer(number)))

    IO.inspect(socket, label: "socket")

    {:noreply, socket}
  end
end
