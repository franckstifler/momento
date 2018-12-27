defmodule MomentoWeb.Resolvers.Accounts do


































  alias Momento.Auth

  def login(_parent, %{email: email, password: password}, _) do
    case Auth.authenticate(email, password) do
      {:ok, user} ->
        token = MomentoWeb.Authentication.sign(%{id: user.id})
        {:ok, %{token: token, user: user}}

      _ ->
        {:error, "incorect email or password"}
    end
  end

  def list_users(_parent, _args, _resolution) do
    {:ok, Momento.Accounts.list_users()}
  end

  def find_user(_parent, %{id: id}, _resolution) do
    case Momento.Accounts.find_user(id) do
      nil ->
        {:error, "User ID #{id} not found"}

      user ->
        {:ok, user}
    end
  end

  def create_user(_parent, user, _resolution) do
    with {:ok, user} <- Momento.Accounts.create_user(user) do
      {:ok, %{user: user}}
    end
  end
end
