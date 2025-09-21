defmodule HeadsUpWeb.IncidentLive.Show do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    incident = Incidents.get_incident!(id)

    # Because each `assign` function is called **synchronously**, the
    # simulated delay we added to `urgent_incidents` slows down the page load.
    socket =
      socket
      |> assign(:incident, incident)
      |> assign(:page_title, incident.name)
      # |> assign(:urgent_incidents, Incidents.urgent_incidents(incident))
      |> assign_async(:urgent_incidents, fn ->
        {:ok, %{urgent_incidents: Incidents.urgent_incidents(incident)}}
        # {:error, "Nyuk, nyuk, nyuk!"}
      end)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-show">
      <div class="incident">
        <img src={@incident.image_path} />
        <section>
          <.badge status={@incident.status} />
          <header>
            <div>
              <h2>{@incident.name}</h2>
              <h3>{@incident.category.name}</h3>
            </div>
            <div class="priority">
              {@incident.priority}
            </div>
          </header>
          <div class="description">
            {@incident.description}
          </div>
        </section>
      </div>
      <div class="activity">
        <div class="left"></div>
        <div class="right">
          <.urgent_incidents incidents={@urgent_incidents} />
        </div>
      </div>
      <.back navigate={~p"/incidents"}>
        All Incidents
      </.back>
    </div>
    """
  end

  attr :incidents, :list, required: true

  def urgent_incidents(assigns) do
    ~H"""
    <section>
      <h4>Urgent Incidents</h4>
      <.async_result :let={result} assign={@incidents}>
        <:loading>
          <div class="loading">
            <div class="spinner" />
          </div>
        </:loading>
        <:failed :let={{:error, reason}}>
          <div class="failed">
            Oh, a wise guy, huh? Woop-oop-oops! {reason}
          </div>
        </:failed>
        <!--
        The following block is in the "default slot" of the `async_result`
        component. As a consequence, it is only rendered when the result
        is available.
        -->
        <ul class="incidents">
          <li :for={incident <- result}>
            <.link navigate={~p"/incidents/#{incident}"}>
              <img src={incident.image_path} /> {incident.name}
            </.link>
          </li>
        </ul>
      </.async_result>
    </section>
    """
  end
end
