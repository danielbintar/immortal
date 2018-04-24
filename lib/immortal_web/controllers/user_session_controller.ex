defmodule ImmortalWeb.UserSessionController do
  use ImmortalWeb, :controller

  alias Immortal.Auth
  alias Immortal.Auth.User
  alias Immortal.Auth.Guardian

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    Auth.authenticate_user(username, password)
    |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: "/")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: user_session_path(conn, :login))
  end

  def secret(conn, _params) do
    render(conn, "secret.html")
  end
end
