defmodule ImmortalWeb.ChatChannel do
  use Phoenix.Channel

  require Logger

  def join("chat:all", _params, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    message = "#{socket.assigns.current_character.name}: #{body}"
    broadcast! socket, "new_msg", %{body: message}
    {:noreply, socket}
  end
end