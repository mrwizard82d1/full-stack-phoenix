defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents
  alias HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:incidents, Incidents.list_incidents(), page_title: "Incidents")
      |> assign(:form, to_form(%{}))

    # IO.inspect(socket.assigns.streams.incidents, label: "MOUNT")

    # socket =
    #   attach_hook(socket, :log_stream, :after_render, fn socket ->
    #     IO.inspect(socket.assigns.streams.incidents, label: "AFTER RENDER")
    #     socket
    #   end)

    {:ok, socket}
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

      <.filter_form form={@form} />

      <div class="incidents" id="incidents" phx-update="stream">
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
    <.form for={@form}>
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" />

      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={[:pending, :canceled, :resolved]}
      />

      <.input type="select" field={@form[:sort_by]} prompt="Sort by" options={[:name, :priority]} />
    </.form>
    """
  end

  attr :incident, HeadsUp.Incidents.Incident, required: true
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident}"} id={@id}>
      <div class="card">
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
end
