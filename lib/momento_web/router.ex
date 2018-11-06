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

  pipeline :auth_api do
    plug Momento.Guardian.AuthPipeline
  end

  pipeline :graphql do
    plug MomentoWeb.Context
  end


  # Other scopes may use custom stacks.
  scope "/api", MomentoWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create, :show]
    post "/session", UserController, :sign_in

  end

  scope "/api", MomentoWeb do
    pipe_through [:api, :auth_api]

    resources "/users", UserController, only: [:index, :update, :delete]
  end

  scope "/api" do
    pipe_through [:api, :graphql]

    forward "/graphiql", Absinthe.Plug.GraphiQL,
            schema: MomentoWeb.Schema
            # interface: :simple
  end
end
