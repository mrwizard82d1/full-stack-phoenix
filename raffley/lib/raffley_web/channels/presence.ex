defmodule RaffleyWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :raffley,
    pubsub_server: Raffley.PubSub

  def init(_opts) do
    # Must return an `:ok` tuple with any custom state
    #
    # In our specific circumstance, we have no custom state to track.
    # We model this situation with an empty `Map`.
    {:ok, %{}}
  end

  def handle_metas(topic, %{joins: joins, leaves: leaves}, presences, state) do
    # We must walk through each item in `joins` and in `leaves` and
    # broadcast a message announcing these events.
    for {username, _presence} <- joins do
      presence = %{id: username, metas: Map.fetch!(presences, username)}

      msg = {:user_joined, presence}

      Phoenix.PubSub.local_broadcast(Raffley.PubSub, "updates:" <> topic, msg)
    end

    for {username, _presence} <- leaves do
      metas =
        case Map.fetch(presences, username) do
          {:ok, presence_metas} -> presence_metas
          # If `username` has left **all** presences, `Map.fetch` will
          # return `:error`. We then return an empty list.
          :error -> []
        end

      presence = %{id: username, metas: metas}

      msg = {:user_left, presence}

      Phoenix.PubSub.local_broadcast(Raffley.PubSub, "updates:" <> topic, msg)
    end

    {:ok, state}
  end
end
