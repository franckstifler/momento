defmodule MomentoWeb.Schema.CommentTypes do
  alias Absinthe.Resolution.Helpers
  use Absinthe.Schema.Notation

  object :comment do
    field(:id, :id)
    field(:comment, non_null(:string))
    field(:inserted_at, :naive_datetime)
    field(:update_at, :naive_datetime)
    field(:user, :user, resolve: Helpers.dataloader(Momento.Accounts))
    field(:user, :user)
  end

  object :comment_result do
    field(:comment, :comment)
    field(:errors, list_of(:input_error))
  end
end
