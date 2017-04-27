# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ex_users,
  ecto_repos: [ExUsers.Repo]

# Configures the endpoint
config :ex_users, ExUsers.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YrBJ/dz+BGuRMmNgqMCTVNIAkiWj4liMfPiF5Ay0IVP1za+P5dFW9aPwsbkmvnxG",
  render_errors: [view: ExUsers.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExUsers.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
