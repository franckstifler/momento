defmodule MomentoWeb.Resolvers.Accounts do

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
end
