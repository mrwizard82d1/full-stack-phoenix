defmodule Raffley.Charities.Charity do
  alias Hex.Solver.Constraints.Impl
  use Ecto.Schema
  import Ecto.Changeset

  schema "charities" do
    field :name, :string
    field :slug, :string

    # One calls `has_many` in the entity that **is the target of** the
    # foreign key.
    #
    # This action creates a single field: `raffle`.
    #
    # Defining the `has_many` relationship is **optional**. If we do not
    # need it, we can simply omit it. If we include it, we can use it to
    # easily query from the charity to all its associated raffles.
    has_many :raffles, Raffley.Raffles.Raffle

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(charity, attrs) do
    charity
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
    |> unique_constraint(:name)
  end
end
