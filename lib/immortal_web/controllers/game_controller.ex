defmodule ImmortalWeb.GameController do
  use ImmortalWeb, :controller

  alias Immortal.Characters
  alias Immortal.CurrentCharacters

  def game(conn, _params) do
    character = Characters.get_character!(get_session(conn, :character_id))
    characters = CurrentCharacters.get()
    conn |> render("game.html", character: character, characters: characters)
  end
end
