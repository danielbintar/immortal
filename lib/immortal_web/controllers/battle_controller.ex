defmodule ImmortalWeb.BattleController do
  use ImmortalWeb, :controller
  alias Immortal.Repo

  def index(conn, _params) do
    characters = Repo.all(Immortal.Characters.Character)
    conn |> render("index.html", characters: characters)
  end

  def p2p(conn, _params) do
    # characters = Repo.all(Immortal.Characters.Character)
    conn |> render("p2p.html")
  end
end
