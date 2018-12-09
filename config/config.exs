# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :vmeste,
  ecto_repos: [Vmeste.Repo]

# Configures the endpoint
config :vmeste, VmesteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "se5UIp1564qpa0UYDnATPIIyw6nX/nv3HKT3det3O459yFVdlcPGndM+nJkS58B8",
  render_errors: [view: VmesteWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Vmeste.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
