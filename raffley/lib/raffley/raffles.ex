defmodule Raffley.Raffles do
  alias Raffley.Repo
  alias Raffley.Raffles.Raffle

  import Ecto.Query

  def list_raffles do
    Repo.all(Raffle)
  end

  def filter_raffes do
    from(
      Raffle
      |> where(status: :closed)
      |> order_by(:prize)
      |> Repo.all()
    )
  end

  def get_raffle!(id) do
    Repo.get!(Raffle, id)
  end

  def featured_raffles(raffle) do
    list_raffles()
    |> List.delete(raffle)
  end
end
