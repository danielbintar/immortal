defmodule ImmortalWeb.MapChannel do
  use Phoenix.Channel

  require Logger

  alias Immortal.Characters

  def join("map:all", _params, socket) do
    {:ok, socket}
  end

  def handle_in("move", params, socket) do
  	character = socket.assigns.current_character
    # user = socket.assigns.current_user
    x = character.position_x
    y = character.position_y
    previous_x = x
    previous_y = y

    case params["direction"] do
    	"up" ->
    		y = y - 1
    	"down" ->
    		y = y + 1
    	"left" ->
    		x = x - 1
    	"right" ->
    		x = x + 1
    end

    l = :ets.lookup(:map_character_position, {x, y})
    targeted_character_id = elem(Enum.at(l, 0), 1)

    if(targeted_character_id != 0 && targeted_character_id != character.id) do
      p2p(character.id, targeted_character_id, socket)
      Logger.info "battle"
      Logger.info targeted_character_id
    else
      character = Map.put(character, :position_x, x)
      character = Map.put(character, :position_y, y)
      socket = assign(socket, :current_character, character)
      Characters.update_character(character, %{"position_x" => x, "position_y" =>  y})
      :ets.insert(:map_character_position, {{previous_x, previous_y}, 0})
      :ets.insert(:map_character_position, {{x, y}, character.id})

      broadcast! socket, "player_position", %{id: character.id, x: x, y: y}
    end

    {:noreply, socket}
  end

  def p2p(character_id, enemy_id, socket) do
    room = Immortal.Battles.create_battle(%{player1: character_id, player2: enemy_id})
    {_temp, room_id} = Enum.at(:ets.lookup(:battle_room, "counter"), 0)
    new_room_id = room_id + 1
    :ets.insert(:battle_room, {"counter", new_room_id})
    :ets.insert(:battle_room, {"room_" <> Kernel.inspect(new_room_id), room})

    broadcast! socket, "force_battle", %{id: character_id, room: new_room_id}
    broadcast! socket, "force_battle", %{id: enemy_id, room: new_room_id}
  end
end
