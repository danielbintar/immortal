defmodule ImmortalWeb.MapChannel do
  use Phoenix.Channel

  require Logger

  alias Immortal.Characters

  def join("map:all", _params, socket) do
    {:ok, socket}
  end

  def handle_in("move", params, socket) do
  	character = socket.assigns.current_character
    user = socket.assigns.current_user
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
    targeted_user_id = elem(Enum.at(l, 0), 1)

    if(targeted_user_id != 0 && targeted_user_id != user.id) do
      Logger.info "battle"
      Logger.info targeted_user_id
    else
      character = Map.put(character, :position_x, x)
      character = Map.put(character, :position_y, y)
      socket = assign(socket, :current_character, character)
      Characters.update_character(character, %{"position_x" => x, "position_y" =>  y})
      :ets.insert(:map_character_position, {{previous_x, previous_y}, 0})
      :ets.insert(:map_character_position, {{x, y}, user.id})

      broadcast! socket, "player_position", %{id: character.id, x: x, y: y}
    end

    {:noreply, socket}
  end
end
