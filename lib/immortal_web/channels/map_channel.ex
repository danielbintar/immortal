defmodule ImmortalWeb.MapChannel do
  use Phoenix.Channel

  def join("map:all", _params, socket) do
    {:ok, socket}
  end

  def handle_in("move", params, socket) do
  	character = socket.assigns.current_character
    character = case params["direction"] do
    	"up" ->
    		character |> Map.update(:position_y, 1, &(&1 - 1))
    	"down" ->
    		character |> Map.update(:position_y, 1, &(&1 + 1))
    	"left" ->
    		character |> Map.update(:position_x, 1, &(&1 - 1))
    	"right" ->
    		character |> Map.update(:position_x, 1, &(&1 + 1))
    end
    socket = assign(socket, :current_character, character)

    broadcast! socket, "player_position", %{x: character.position_x, y: character.position_y}
    {:noreply, socket}
  end
end
