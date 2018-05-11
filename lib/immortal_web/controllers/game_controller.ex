defmodule ImmortalWeb.GameController do
  use ImmortalWeb, :controller

  alias Immortal.Auth
  alias Immortal.Auth.User
  alias Immortal.Auth.Guardian
  alias Immortal.Characters

  def game(conn, _params) do
    character = Characters.get_character!(get_session(conn, :character_id))
    conn |> render("game.html", character: character)
  end
end
