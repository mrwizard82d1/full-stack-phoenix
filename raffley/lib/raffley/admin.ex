defmodule Raffley.Admin do
  alias Raffley.Raffles.Raffle
  alias Raffley.Repo

  import Ecto.Query

  def list_raffles do
    Raffle
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  # Remember that the name `attrs` is a **convention**. The name `attrs`
  # is short for attributes.
  def create_raffle(attrs \\ %{}) do
    %Raffle{}
    |> Raffle.changeset(attrs)
    |> Repo.insert()
  end

  # By convention, the name `change_raffle` is called to validate the
  # Raffle changeset.
  #
  # By convention, we match the first parameter to its type. This, we
  # enforce that the first parameter, `raffle` matches the `Raffle` struct.
  #
  # Remember, too, that the attributes, `attrs` are **optional**. The
  # value of this arguments defaults to an empty map.
  #
  # Unfortunately, the name of this function **can be misleading**. This
  # function does not actually change the raffle, but, instead, creates
  # a changeset. Additionally, it may seem silly to create a function that
  # performs a single transformation; however, in experience, this function
  # is more useful than is apparent.
  def change_raffle(%Raffle{} = raffle, attrs \\ %{}) do
    Raffle.changeset(raffle, attrs)
  end

  def get_raffle!(id) do
    Repo.get!(Raffle, id)
  end

  def update_raffle(%Raffle{} = raffle, attrs) do
    raffle
    |> Raffle.changeset(attrs)
    |> Repo.update()
  end
end
