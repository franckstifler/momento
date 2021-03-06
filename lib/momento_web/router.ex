defmodule MomentoWeb.Router do
  use MomentoWeb, :router

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

  scope "/", MomentoWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  pipeline :graphql do
    plug MomentoWeb.Context
  end


  scope "/" do
    pipe_through [:api, :graphql]

    forward "/api", Absinthe.Plug, schema: MomentoWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
            schema: MomentoWeb.Schema
            # interface: :simple
  end
end
