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

    socket =
      socket
      |> assign(:raffle, raffle)
      |> assign(:page_title, raffle.prize)
      # Simulate that an error occurs when fetching featured raffles.
      |> assign_async(:featured_raffles, fn ->
        # {:ok, %{featured_raffles: Raffles.featured_raffles(raffle)}}
        {:error, "Out to lunch!"}
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
          <.featured_raffles raffles={@featured_raffles} />
        </div>
      </div>
    </div>
    """
  end

  def featured_raffles(assigns) do
    ~H"""
    <section>
      <h4>Featured Raffles</h4>
      <div :if={@raffles.loading} class="loading">
        <div class="spinner"></div>
      </div>
      <!--
      Because `@raffles` is an asynchronous result, we need to check if
      it has been resolved **before** attempting to render each
      featured raffle.
      -->
      <ul :if={@raffles.ok?} class="raffles">
        <!--
        Because we are fetching the raffles asynchronously, we now query
        the asynchronous result of the fetch. This action will implicitly
        await the asynchronous result.
        -->
        <li :for={raffle <- @raffles.result}>
          <.link navigate={~p"/raffles/#{raffle}"}>
            <img src={raffle.image_path} /> {raffle.prize}
          </.link>
        </li>
      </ul>
    </section>
    """
  end
end
