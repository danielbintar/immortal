defmodule ImmortalWeb.BattleChannel do
  use Phoenix.Channel

  def join("battle:p2p" <> room_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("action", %{"body" => body}, socket) do
    action = body["action"]
    room_id = body["room_id"]

    {_temp, room} = Enum.at(:ets.lookup(:battle_room, "room_" <> room_id), 0)
    if (socket.assigns.current_character.id == room.changes.player1) do
      enemy_id = room.changes.player2
    else
      enemy_id = room.changes.player1
    end
    player = socket.assigns.current_character
    player_id = player.id
    enemy = Immortal.Characters.get_character!(enemy_id)

    if (action == "attack") do
      enemy_health = enemy.health - player.attack
      player_health = player.health
      Immortal.Characters.update_character(enemy, %{health: enemy_health})
      message = "#{player.name} attacks and deals #{player.attack} damages"
    end
    body = %{
      enemy: %{
        id: enemy_id,
        health: enemy_health
      },
      player: %{
        id: player_id,
        health: player_health
      },
      message: message
    }

    broadcast! socket, "update", body
    {:reply, :ok, socket}
  end

  def handle_out("join_game", payload, socket) do
    room_id = payload.room_id
    {_temp, room} = Enum.at(:ets.lookup(:battle_room, "room_" <> Kernel.inspect(room_id)), 0)
    if (socket.assigns.current_character.id == room.changes.player2) do
      push socket, "join_game", payload
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

end
