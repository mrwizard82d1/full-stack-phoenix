defmodule Raffley.Raffles.Raffle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "raffles" do
    field :status, Ecto.Enum,
      values: [:upcoming, :open, :closed],
      default: :upcoming

    field :description, :string
    field :prize, :string
    field :ticket_price, :integer, default: 1
    field :image_path, :string, default: "/images/placeholder.jpg"

    # One calls `belongs_to` in the entity that **has** the foreign key.
    #
    # This action creates two fields: `charity_id` and `charity`.
    belongs_to :charity, Raffley.Charities.Charity

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(raffle, attrs) do
    raffle
    |> cast(attrs, [:prize, :description, :ticket_price, :status, :image_path, :charity_id])
    |> validate_required([:prize, :description, :ticket_price, :status, :image_path, :charity_id])
    # Phoenix generated these validations for us. Let's add some custom ones.
    |> validate_length(:description, min: 10)
    |> validate_number(:ticket_price, greater_than_or_equal_to: 1)
    # Converts an exception due to missing charity (small but non-zero
    # window) to a changeset error.
    |> assoc_constraint(:charity)
  end
end
