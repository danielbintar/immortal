defmodule ImmortalWeb.Router do
  use ImmortalWeb, :router

  require Logger

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Immortal.Auth.Pipeline
    plug :put_user_token
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  # Maybe logged in scope
  scope "/", ImmortalWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/game", GameController, :game
    get "/play/:id", PageController, :play

    get "/battle/index", BattleController, :index
    get "/battle/p2p/:room_id", BattleController, :p2p

    resources "/characters", CharacterController

    post "/", UserSessionController, :login
    get "/logout", UserSessionController, :logout

    get "/register", UserController, :new
    post "/register", UserController, :create
  end

  defp put_user_token(conn, _) do
    if current_user = Guardian.Plug.current_resource(conn) do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ImmortalWeb do
  #   pipe_through :api
  # end
end
