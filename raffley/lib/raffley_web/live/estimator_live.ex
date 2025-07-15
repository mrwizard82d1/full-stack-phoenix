defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  # A LiveView module defines three primary callback functions
  # `mount/3`
  # `render/1`
  # `handel_event`

  def mount(_params, _session, socket) do
    # Assigns two pieces of "state" for our "socket"
    socket = assign(socket, tickets: 0, price: 3)

    # What does a socket look like?
    IO.inspect(socket)

    # Must return a two-item tuple
    {:ok, socket}

    # Note that the return value of `socket` is often inlined "in the wild"
    # {:ok, assign(socket, tickets: 0, price: 3)}
  end

  # By moving / including a heex template, in this case,
  # `estimator_live.html.heex`, we can use the `render/1` function provided
  # by the framework (I believe).
end
