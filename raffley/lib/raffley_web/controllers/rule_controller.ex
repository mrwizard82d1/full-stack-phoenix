defmodule RaffleyWeb.RuleController do
  use RaffleyWeb, :controller

  def index(conn, _params) do
    emojis =
      ~w(\u{1f600} \u{1f917} \u{270c})
      |> Enum.random()
      |> String.duplicate(5)

    render(conn, :index, emojis: emojis)
  end
end
