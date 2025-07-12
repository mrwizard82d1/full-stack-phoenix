defmodule RaffleyWeb.RuleController do
  use RaffleyWeb, :controller

  alias Raffley.Rules

  def index(conn, _params) do
    emojis =
      ~w(\u{1f600} \u{1f917} \u{270c})
      |> Enum.random()
      |> String.duplicate(5)

    rules = Rules.list_rules()

    render(conn, :index, emojis: emojis, rules: rules)
  end

  def show(conn, %{"id" => id}) do
    rule = Rules.get_rule(id)
    render(conn, :show, rule: rule)
  end
end
