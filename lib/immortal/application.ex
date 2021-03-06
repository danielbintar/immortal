defmodule Immortal.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    Immortal.Maps.init()
    Immortal.CurrentCharacters.init()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Immortal.Repo, []),
      # Start the endpoint when the application starts
      supervisor(ImmortalWeb.Endpoint, []),
      # Start your own worker by calling: Immortal.Worker.start_link(arg1, arg2, arg3)
      # worker(Immortal.Worker, [arg1, arg2, arg3]),
    ]

    :ets.new(:battle_room, [:named_table, :public])
    :ets.insert(:battle_room, {"counter", 0})

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Immortal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ImmortalWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
