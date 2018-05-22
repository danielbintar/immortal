defmodule ImmortalWeb.BattleController do
  use ImmortalWeb, :controller
  alias Immortal.Repo

  def index(conn, _params) do
    characters = Repo.all(Immortal.Characters.Character)
    conn |> render("index.html", characters: characters)
  end

  def p2p(conn, %{"room_id" => room_id}) do
    # require IEx; IEx.pry
    {_temp, room} = Enum.at(:ets.lookup(:battle_room, "room_" <> room_id), 0)
    player = Immortal.Characters.get_character!(get_session(conn, :character_id))
    if (player.id == room.changes.player1) do
      enemy_id = room.changes.player2
    else
      enemy_id = room.changes.player1
    end
    enemy = Immortal.Characters.get_character!(enemy_id)
    player_id = player.id

    # require IEx; IEx.pry

    #Immortal.Endpoint.broadcast("join_game", msg)

    conn |> render("p2p.html", character: player, enemy: enemy, room: room_id)
  end
end
