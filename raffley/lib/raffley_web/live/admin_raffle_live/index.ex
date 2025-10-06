defmodule RaffleyWeb.AdminRaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Admin
  import RaffleyWeb.CustomComponents

  # Run authorization checks
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Raffles")
      |> stream(:raffles, Admin.list_raffles())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <!--
      Remember, the expression, "#joke", refers to the element with the
      id, "joke".

      Additionally, the expression `JS.toggle` is **not** run when the
      form is rendered; instead, Phoenix transforms the expression into
      a number of client side HTML / JavaScript fragments that toggle the
      visibility of the joke.

      We previously used CSS classes to control the fade-in and fade-out
      of the joke. This approach assumes that such CSS classe are available
      to us.

      The following approach uses a mechanism that is always available
      to us: passing a tuple to control the transition.
      -->
      <.button phx-click={
        JS.toggle(
          to: "#joke",
          in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
          out: {"ease-in-out duration=300", "opacity-100", "opacity-0"},
          time: 300
        )
      }>
        Toggle Joke
      </.button>
      <div id="joke" class="joke hidden">
        What's a tree's favorite drink, {@current_user.username}?
      </div>
      <.header class="mt-6">
        {@page_title}
        <:actions>
          <.link class="button" navigate={~p"/admin/raffles/new"}>
            New Raffle
          </.link>
        </:actions>
      </.header>
      <.table
        id="raffles"
        rows={@streams.raffles}
        row_click={fn {_, raffle} -> JS.navigate(~p"/raffles/#{raffle}") end}
      >
        <:col :let={{_dom_id, raffle}} label="Prize">
          <.link navigate={~p"/raffles/#{raffle}"}>
            {raffle.prize}
          </.link>
        </:col>
        <:col :let={{_dom_id, raffle}} label="Status">
          <.badge status={raffle.status} />
        </:col>
        <:col :let={{_dom_id, raffle}} label="Ticket Price">
          {raffle.ticket_price}
        </:col>
        <:action :let={{_dom_id, raffle}}>
          <.link navigate={~p"/admin/raffles/#{raffle}/edit"}>
            Edit
          </.link>
        </:action>
        <:action :let={{dom_id, raffle}}>
          <.link phx-click={delete_and_hide(dom_id, raffle)} data-confirm="Are you sure?">
            Delete
          </.link>
        </:action>
      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    raffle = Admin.get_raffle!(id)

    # Delete the raffle from the database but...
    {:ok, _} = Admin.delete_raffle(raffle)

    # ... we must also delete it from the stream (used to render our page)
    {:noreply, stream_delete(socket, :raffles, raffle)}
  end

  def delete_and_hide(dom_id, raffle) do
    JS.push("delete", value: %{id: raffle.id})
    |> JS.hide(to: "##{dom_id}", transition: "fade-out")
  end
end
