defmodule MomentoWeb.Schema do
    use Absinthe.Schema

    import_types Absinthe.Type.Custom

    import_types MomentoWeb.Schema.UserTypes
    import_types MomentoWeb.Schema.SliceTypes
    import_types MomentoWeb.Schema.VideoTypes

    alias MomentoWeb.Resolvers

    query do

        @desc "Get all users"
        field :users, list_of(:user) do
            resolve &Resolvers.Accounts.list_users/3
        end

        @desc "Get a user of momento"
        field :user, :user do
            arg :id, non_null(:id)
            resolve &Resolvers.Accounts.find_user/3
        end
    end

    mutation do

        @desc "create a slice"
        field :create_slice, type: :slice do
            arg :start_time, non_null(:integer)
            arg :end_time, non_null(:integer)

            resolve &Resolvers.Media.create_slice/3
        end
    end
end
