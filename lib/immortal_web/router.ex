defmodule ImmortalWeb.Router do
  use ImmortalWeb, :router

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
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  # Maybe logged in scope
  scope "/", ImmortalWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/game", PageController, :game
    get "/play/:id", PageController, :play

    resources "/characters", CharacterController

    post "/", UserSessionController, :login
    get "/logout", UserSessionController, :logout

    get "/register", UserController, :new
    post "/register", UserController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", ImmortalWeb do
  #   pipe_through :api
  # end
end
