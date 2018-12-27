defmodule MomentoWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation
  alias Absinthe.Resolution.Helpers

  object :user do
    field(:id, :id)
    field(:email, :string)
    field(:username, :string)

    field(:slices, list_of(:slice), resolve: Helpers.dataloader(Momento.Media))
  end

  object :session do
    field(:token, :string)
    field(:user, :user)
  end

  object :user_result do
    field(:errors, list_of(:input_error))
    field(:user, :user)
  end
end
