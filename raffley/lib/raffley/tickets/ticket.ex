defmodule Raffley.Tickets.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :comment, :string
    field :price, :integer

    # These `belongs_to` associations duplicate a declaration of the
    # two fields: `raffle_id` and `user_id` (which were generated but
    # then replaced).
    belongs_to :raffle, Raffley.Raffles.Raffle
    belongs_to :user, Raffley.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:price, :comment])
    |> validate_required([:price])
    |> validate_length(:comment, max: 100)
    |> assoc_constraint(:raffle)
    |> assoc_constraint(:user)
  end
end
