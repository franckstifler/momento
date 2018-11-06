defmodule MomentoWeb.Resolvers.Media do

  def list_slices(%Momento.Accounts.User{} = author, args, _resolution) do
    {:ok, Momento.Media.list_slices(author, args)}
  end

  def list_slices(_parent, _args, _resolution) do
    {:ok, Momento.Media.list_slices()}
  end

  def create_slice(_parent, args, %{context: %{current_user: user}}) do
    Momento.Media.create_slice(user, args)
  end
end
