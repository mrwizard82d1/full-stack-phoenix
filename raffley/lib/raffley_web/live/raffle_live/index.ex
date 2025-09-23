defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Charities
  alias Raffley.Raffles
  import RaffleyWeb.CustomComponents

  # Remember, `mount/3` is **not** invoked from calls to `patch` or to `push_patch`.
  # Because `mount/3` is **not** invoked from these calls, we need to
  # - Move "initialization" code to `handle_params/3` if possible.
  #
  # Remember, too, if you **call neither** `patch` nor `push_patch`,
  # one **may** perform initialization in either:
  # - `mount/3` or
  # - `handle_params/3`
  def mount(_params, _session, socket) do
    # IO.inspect(socket.assigns.streams.raffles, label: "MOUNT")

    socket =
      assign(socket, :charity_options, Charities.charity_names_and_slugs())

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    # This function is the appropriate place to **filter** our
    # raffles based on the provided parameters.

    # After changing implementation to call `patch` variants instead of
    # `navigate`, we have a problem: The call to `stream` **does not reset**
    # the view data. We mut add the `reset: true` argument to reset the
    # stream data.
    socket =
      socket
      |> stream(:raffles, Raffles.filter_raffles(params), reset: true)
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <.banner :if={false}>
        <.icon name="hero-sparkles-solid" /> Mystery  Raffle Coming Soon!
        <:details :let={vibe}>
          To Be Revealed Tomorrow {vibe}
        </:details>
        <:details>
          Any guesses?
        </:details>
      </.banner>

      <.filter_form form={@form} charity_options={@charity_options} />

      <div class="raffles" id="raffles" phx-update="stream">
        <.raffle_card :for={{dom_id, raffle} <- @streams.raffles} raffle={raffle} id={dom_id} />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" phx-debounce="500" />

      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={[:upcoming, :open, :closed]}
      />

      <.input type="select" field={@form[:charity]} prompt="Charity" options={@charity_options} />

      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Sort by"
        options={[
          Prize: "prize",
          "Price: High to Low": "ticket_price_desc",
          "Price: Low to High": "ticket_price_asc",
          Charity: "charity"
        ]}
      />

      <.link patch={~p"/raffles"}>
        Reset
      </.link>
    </.form>
    """
  end

  attr :raffle, Raffley.Raffles.Raffle, required: true
  attr :id, :string, required: true

  def raffle_card(assigns) do
    ~H"""
    <.link navigate={~p"/raffles/#{@raffle}"} id={@id}>
      <div class="card">
        <div class="charity">
          {@raffle.charity.name}
        </div>
        <img src={@raffle.image_path} />
        <h2>{@raffle.prize}</h2>
        <div class="details">
          <div class="price">
            ${@raffle.ticket_price} / ticket
          </div>
          <.badge status={@raffle.status} />
        </div>
      </div>
    </.link>
    """
  end

  # Handle filter events (see `phx-change` in `filter_form/1`)
  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by charity))
      |> Map.reject(fn {_, v} -> v == "" end)

    # Calling `push_patch`
    # - Does not perform a "dismount/mount" cycle
    # - But "patches" the current view with the filtered data
    socket = push_patch(socket, to: ~p"/raffles?#{params}")

    {:noreply, socket}
  end
end
