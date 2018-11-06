defmodule MomentoWeb.Schema.UserTypes do
    use Absinthe.Schema.Notation

    alias MomentoWeb.Resolvers

    object :user do
        field :id, :id
        field :email, :string

        field :slices, list_of(:slice) do
            arg :date, :date
            resolve &Resolvers.Media.list_slices/3
        end
    end
end
