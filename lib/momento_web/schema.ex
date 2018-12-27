defmodule MomentoWeb.Schema do




















































































  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)

  import_types(MomentoWeb.Schema.UserTypes)
  import_types(MomentoWeb.Schema.SliceTypes)
  import_types(MomentoWeb.Schema.VideoTypes)

  alias MomentoWeb.Resolvers
  alias MomentoWeb.Middleware.ChangesetErrors

  object :input_error do
    field(:key, non_null(:string))
    field(:message, non_null(:string))
  end

  def middleware(list, _field, %{identifier: :mutation}) do
    list ++ [ChangesetErrors]
  end

  def middleware(list, _arg1, _arg2) do
    list
  end

  def plugins() do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def dataloader do
    alias Momento.Media

    Dataloader.new()
    |> Dataloader.add_source(Media, Media.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve(&Resolvers.Accounts.list_users/3)
    end

    @desc "Get a user of momento"
    field :user, :user do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Accounts.find_user/3)
    end

    @desc "Get all slices"
    field :slices, list_of(:slice) do
      resolve(&Resolvers.Media.list_slices/3)
    end
  end

  mutation do
    @desc "create a slice"
    field :create_slice, type: :slice_result do
      arg(:start_time, non_null(:integer))
      arg(:end_time, non_null(:integer))
      arg(:url, non_null(:string))

      resolve(&Resolvers.Media.create_slice/3)
    end

    field :login, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.login/3)
    end

    field :create_user, type: :user_result do
      arg(:email, non_null(:string))
      arg(:username, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.create_user/3)
    end
  end
end
