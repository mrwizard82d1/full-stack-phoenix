defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents
  alias HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        incidents: Incidents.list_incidents(),
        page_title: "Incidents"
      )

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
      <div class="incidents">
        <.incident_card :for={incident <- @incidents} incident={incident} />
      </div>
    </div>
    """
  end

  attr :incident, HeadsUp.Incident, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident}"}>
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
