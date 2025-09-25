defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Categories
  alias HeadsUp.Incidents
  alias HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    # IO.inspect(socket.assigns.streams.incidents, label: "MOUNT")

    socket =
      assign(socket, :category_options, Categories.category_names_and_slugs())

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> stream(:incidents, Incidents.filter_incidents(params),
        page_title: "Incidents",
        reset: true
      )
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <div class="headline">
        <CustomComponents.headline>
          <.icon name="hero-trophy-mini" /> 25 Incidents Resolved this Month!
          <:tagline :let={vibe}>
            Thanks for pitching in. {vibe}
          </:tagline>
        </CustomComponents.headline>
      </div>

      <.filter_form form={@form} category_options={@category_options} />

      <div class="incidents" id="incidents" phx-update="stream">
        <div id="empty" class="no-results only:block hidden">
          No raffles found. Try changing your filters.
        </div>
        <.incident_card
          :for={{dom_id, incident} <- @streams.incidents}
          incident={incident}
          id={dom_id}
        />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter" phx-submit="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" phx-debounce="500" />

      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={[:pending, :canceled, :resolved]}
      />

      <.input type="select" field={@form[:category]} prompt="Category" options={@category_options} />

      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Sort by"
        options={[
          Name: :name,
          "Priority High-to-Low": :priority_desc,
          "Priority Low-to-High": :priority_asc
        ]}
      />

      <.link patch={~p"/incidents"}>
        Reset
      </.link>
    </.form>
    """
  end

  attr :incident, HeadsUp.Incidents.Incident, required: true
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident}"} id={@id}>
      <div class="card">
        <div class="category">
          {@incident.category.name}
        </div>
        <img src={@incident.image_path} />
        <h2>{@incident.name}</h2>
        <div class="details">
          <CustomComponents.badge status={@incident.status} />
          <div class="priority">
            {@incident.priority}
          </div>
        </div>
      </div>
    </.link>
    """
  end

  # Handle `filter` events (see `phx-change` tag in `filter_form/1`)
  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by category))
      |> Map.reject(fn {_, v} -> v == "" end)

    # Calling `push_navigate`
    # - Dismounts the current view and
    # - Mounts a **new view**
    #
    # This action dismounts the current **filtered** view and then mounts a
    # view with **no filters**! (See `mount/3 for this action.) This call to
    # `mount/3` will be followed by a call to `handle_params/3` to update the
    # state of the new view.
    socket = push_patch(socket, to: ~p"/incidents?#{params}")

    {:noreply, socket}
  end
end
