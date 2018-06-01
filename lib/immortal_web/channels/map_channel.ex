defmodule ImmortalWeb.MapChannel do
  use Phoenix.Channel

  alias Immortal.CurrentCharacters
  alias Immortal.Maps

  def join("map:all", _params, socket) do
    character = socket.assigns.current_character
    CurrentCharacters.put(character)
    {:ok, socket}
  end

  def handle_in("move", params, socket) do
  	character = socket.assigns.current_character
    previous_x = character.position_x
    previous_y = character.position_y

    y = case params["direction"] do
      "up" ->
        character.position_y - 1
      "down" ->
        character.position_y + 1
      _ ->
        character.position_y
    end

    x = case params["direction"] do
      "left" ->
        character.position_x - 1
      "right" ->
        character.position_x + 1
      _ ->
        character.position_x
    end

    targeted_character_id = Maps.value(x, y)

    if(targeted_character_id != 0 && targeted_character_id != character.id) do
      p2p(character.id, targeted_character_id, socket)
    else
      character = Map.put(character, :position_x, x)
      character = Map.put(character, :position_y, y)
      socket = assign(socket, :current_character, character)
      Maps.set_value(previous_x, previous_y, 0)
      Maps.set_value(x, y, character.id)
      CurrentCharacters.put(character)

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
