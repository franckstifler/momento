# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :momento,
  ecto_repos: [Momento.Repo]

# Configures the endpoint
config :momento, MomentoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M4uygVS3T/I1wn6Ek9uFmYRoAUiBK4uuNvpzH37DvltudhUxtwmzQ7XR7oK/q15V",
  render_errors: [view: MomentoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Momento.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :momento, Momento.Guardian,
        issuer: "momento",
        secret_key: "L3zSppjzRfnHUvhTAFzd+NBYOv91ms6Xokl0CDmvb0kJcZ4igVYpkMp7ydv6cbQu"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
