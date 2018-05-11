defmodule ImmortalWeb.PageController do
  use ImmortalWeb, :controller

  alias Immortal.Auth
  alias Immortal.Auth.User
  alias Immortal.Auth.Guardian
  alias Immortal.Characters

  def index(conn, _params) do
    changeset = Auth.change_user(%User{})
    user = Guardian.Plug.current_resource(conn)
    message = if user != nil do
      "1 people is logged in"
    else
      "No one is logged in"
    end

    conn
      |> put_flash(:info, message)
      |> render("index.html", changeset: changeset, action: user_session_path(conn, :login), user: user)
  end

  def play(conn, %{"id" => id}) do
    character = Characters.get_character!(String.to_integer(id))
    conn = put_session(conn, :character_id, character.id)
    conn |> redirect(to: game_path(conn, :game))
  end
end
