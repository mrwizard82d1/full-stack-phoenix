# The module needs to have the text, "JSON", to be all uppercase. See
# other similar modules, `error_html.ex` and `error_json.ex` for examples.
defmodule RaffleyWeb.Api.RaffleJSON do
  # The view module needs a method named `index/1` that accepts `assigns`
  # as an argument. Because we want to **extract** the raffles from the
  # `assigns` map, we use **pattern matching** (and lose explictly
  # naming the actual argument, `assigns`).
  def index(%{raffles: raffles}) do
    %{
      raffles:
        for raffle <- raffles do
          %{
            id: raffle.id,
            prize: raffle.prize,
            description: raffle.description,
            status: raffle.status,
            ticket_price: raffle.ticket_price,
            charity_id: raffle.charity_id
          }
        end
    }
  end
end
