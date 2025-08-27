defmodule RaffleyWeb.RaffleLive.Show do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  import RaffleyWeb.CustomComponents

  def mount(_params, _session, socket) do
    IO.inspect(self(), label: "MOUNT")
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    IO.inspect(self(), label: "HANDLE_PARAMS")
    raffle = Raffles.get_raffle!(id)

    # All the `assign` calls are executed **synchronously**; because
    # we've introduced a delay into `featured_raffles/1`, everything
    # now seems slow.
    socket =
      socket
      |> assign(:raffle, raffle)
      |> assign(:page_title, raffle.prize)
      # The function, `assign_async/2`, takes a key and a function to be
      # executed asynchronously. The function returns a tuple consisting of
      # an atom and a map containing the key passed to `assign_async/2`.
      # In addition, the function argument is then executed asynchronously.
      # This action allows the containing function to return and render
      # the page incompletely while awaiting the result of the asynchronous
      # function.
      |> assign_async(:featured_raffles, fn ->
        {:ok, %{featured_raffles: Raffles.featured_raffles(raffle)}}
      end)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <pre>
      {inspect(@featured_raffles, pretty: true)}
    </pre>
    <div class="raffle-show">
      <div class="raffle">
        <img src={@raffle.image_path} />
        <section>
          <.badge status={@raffle.status} />
          <h2>
            {@raffle.prize}
          </h2>
          <div class="price">
            ${@raffle.ticket_price} / ticket
          </div>
          <div class="description">
            {@raffle.description}
          </div>
        </section>
      </div>
      <div class="activity">
        <div class="left"></div>
        <div class="right">
          <.featured_raffles :if={false} raffles={@featured_raffles} />
        </div>
      </div>
    </div>
    """
  end

  def featured_raffles(assigns) do
    ~H"""
    <section>
      <h4>Featured Raffles</h4>
      <ul class="raffles">
        <li :for={raffle <- @raffles}>
          <.link navigate={~p"/raffles/#{raffle}"}>
            <img src={raffle.image_path} /> {raffle.prize}
          </.link>
        </li>
      </ul>
    </section>
    """
  end
end
