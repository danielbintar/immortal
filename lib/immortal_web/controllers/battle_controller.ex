defmodule ImmortalWeb.BattleController do
  use ImmortalWeb, :controller
  alias Immortal.Repo

  def index(conn, _params) do
    characters = Repo.all(Immortal.Characters.Character)
    conn |> render("index.html", characters: characters)
  end

  def p2p(conn, %{"id" => enemy_id}) do
    # require IEx; IEx.pry

    player = Immortal.Characters.get_character!(get_session(conn, :character_id))
    enemy = Immortal.Characters.get_character!(enemy_id)
    player_id = player.id
    room = Immortal.Battles.create_battle(%{player1: player_id, player2: enemy_id})

    # require IEx; IEx.pry
    {temp, room_id} = Enum.at(:ets.lookup(:battle_room, "counter"), 0)
    new_room_id = room_id + 1
    :ets.insert(:battle_room, {"counter", new_room_id})
    :ets.insert(:battle_room, {"room_" <> Kernel.inspect(new_room_id), room})

    #Immortal.Endpoint.broadcast("join_game", msg)

    conn |> render("p2p.html", character: player, enemy: enemy, room: new_room_id)
  end
end
