defmodule HeadsUpWeb.Api.IncidentController do
  use HeadsUpWeb, :controller

  alias HeadsUp.Admin

  def index(conn, _params) do
    incidents = Admin.list_incidents()
    render(conn, "index.json", incidents: incidents)
  end
end
