defmodule ImmortalWeb.UserSocket do
  use Phoenix.Socket

  alias Immortal.Auth
  alias Immortal.Characters

  channel "chat:*", ImmortalWeb.ChatChannel
  channel "map:*", ImmortalWeb.MapChannel
  ## Channels
  channel "battle:*", ImmortalWeb.BattleChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(params, socket) do
    case Phoenix.Token.verify(socket, "user socket", params["token"], max_age: 1209600) do
      {:ok, user_id} ->
        socket = assign(socket, :current_user, Auth.get_user!(user_id))
        if params["character_id"] do
          character = Characters.get_character!(params["character_id"])
          if character.user_id == user_id do
            socket = assign(socket, :current_character, character)
          end
        end
        {:ok, socket}
      {:error, reason} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     ImmortalWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
