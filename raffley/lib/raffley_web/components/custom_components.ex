defmodule RaffleyWeb.CustomComponents do
  use RaffleyWeb, :html

  # NOTE: Defining a required attribute on a structure passed to a
  # function results in a "compile time issue." Notice the "squiggle"
  # at the beginning of the `.badge` "tag". Additionally, this
  # attribute raises a **compiler error**.
  attr :status, :atom, values: [:upcoming, :open, :closed], default: :upcoming
  attr :class, :string, default: nil

  def badge(assigns) do
    ~H"""
    <div class={[
      "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
      @status == :open && "text-lime-600 border-lime-600",
      @status == :upcoming && "text-amber-600 border-amber-600",
      @status == :closed && "text-gray-600 border-gray-600",
      @class
    ]}>
      {@status}
    </div>
    """
  end

  slot :inner_block, required: true
  slot :details

  def banner(assigns) do
    assigns = assign(assigns, :emoji, ~w(\u{1f600} \u{1f60d} \u{1f917}) |> Enum.random())

    ~H"""
    <div class="banner">
      <h1>
        {render_slot(@inner_block)}
      </h1>
      <div :for={details <- @details} class="details">
        {render_slot(details, @emoji)}
      </div>
    </div>
    """
  end
end
