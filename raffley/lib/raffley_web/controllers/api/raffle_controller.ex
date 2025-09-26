defmodule RaffleyWeb.Api.RaffleController do
  use RaffleyWeb, :controller

  alias Raffley.Admin

  def index(conn, _params) do
    # One way to fetch the raffles is to use an existing method in the
    # `Raffles` module. Another possibility is to use the Admin` module.
    # A third possibility is to create a new module, for example, `Api`,
    # and implement an API-specific `list_raffles/0` function. This
    # provides us with the ability to perform some "pre-processing" of
    # raffles before returning them to the client. Our choice: use the
    # existing `Admin.list_raffles/0` function.
    raffles = Admin.list_raffles()

    # We must define the `render/3` function but where? We define this
    # function in a view module. By default, Phoenix looks for a view
    # module based on the controller name, `Raffle`, and the request
    # format, `JSON` (all uppercase).
    render(conn, :index, raffles: raffles)
  end
end
