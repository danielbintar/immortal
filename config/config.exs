# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :immortal,
  ecto_repos: [Immortal.Repo]

config :immortal, Immortal.Auth.Guardian,
  issuer: "immortal", # Name of your app/company/product
  secret_key: "Ce2mIi1FZM/A9GcflZjf/xoYfEAl2tfPwSqjOoINub5BdeAeQF9G+0VFMfKPQLY3" # Replace this with mix guardian.gen.secret

# Configures the endpoint
config :immortal, ImmortalWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MuQMyOXHQ6h9pDIJvQ6dO57WClU1GzsVmFCDPBZv/VQ9xe8/PiiT2lhlOfDdzBck",
  render_errors: [view: ImmortalWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Immortal.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
