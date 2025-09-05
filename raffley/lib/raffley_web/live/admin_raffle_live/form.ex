defmodule RaffleyWeb.AdminRaffleLive.Form do
  use RaffleyWeb, :live_view

  alias Raffley.Admin
  alias Raffley.Raffles.Raffle

  def mount(_params, _session, socket) do
    # Create a `ChangeSet` from an empty `Raffle` struct and an empty set
    # of attributes (`attrs`).
    changeset = Raffle.changeset(%Raffle{}, %{})

    socket =
      socket
      |> assign(:page_title, "New Raffle")
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>

    <.simple_form for={@form} id="raffle-form" phx-submit="save" phx-change="validate">
      <!--
      Errors are handled "automagically" by Phoenix. The function,
      `Admin.create_raffle/1`, creates a new raffle. But this function
      calls `Raffle.changeset/2` with the data for the Raffle to create.
      `Raffle.changeset/2` returns a changeset, but it also validates the
      candidate data for the Raffle that is to be created. If the data is
      invalid, the changeset will contain the errors which should be
      displayed to the user.
      -->
      <.input field={@form[:prize]} label="Prize" />
      <.input field={@form[:description]} type="textarea" label="Description" phx-debounce="blur" />
      <.input field={@form[:ticket_price]} type="number" label="Ticket Price" />
      <.input
        field={@form[:status]}
        type="select"
        label="Status"
        prompt="Choose a status"
        options={[:upcoming, :open, :closed]}
      />
      <.input field={@form[:image_path]} label="Image Path" />

      <:actions>
        <.button phx-disable-with="Saving...">Save Raffle</.button>
      </:actions>
    </.simple_form>

    <pre>
      {inspect(@form, pretty: true)}
    </pre>

    <.back navigate={~p"/admin/raffles"}>
      Back
    </.back>
    """
  end

  def handle_event("validate", %{"raffle" => raffle_params}, socket) do
    changeset = Raffle.changeset(%Raffle{}, raffle_params)
    socket = assign(socket, :form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end

  def handle_event("save", %{"raffle" => raffle_params}, socket) do
    # Ignore the returned value.
    case Admin.create_raffle(raffle_params) do
      # Since `create_raffle/1` now returns a tuple, we pattern match
      # on that returned tuple.
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "Raffle created successfully")
          |> push_navigate(to: ~p"/admin/raffles")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        # Include "errors" in data assigned to `socket`
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end
end
