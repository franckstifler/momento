defmodule MomentoWeb.Schema.SliceTypes do
  alias Absinthe.Resolution.Helpers
  use Absinthe.Schema.Notation

  @desc "A slice of a video url"
  object :slice do
    field(:id, :id)
    field(:start_time, :integer)
    field(:end_time, :integer)
    field(:video, :video, resolve: Helpers.dataloader(Momento.Media))
    field(:user, :user, resolve: Helpers.dataloader(Momento.Accounts))
    field(:published_at, :naive_datetime)
    field(:tags, list_of(:tag), resolve: Helpers.dataloader(Momento.Media))
    field(:comments, list_of(:comment), resolve: Helpers.dataloader(Momento.Media))
    field(:likes, :integer)
  end

  object :slice_result do
    field(:slice, :slice)
    field(:errors, list_of(:input_error))
  end

  object :tag do
    field(:id, :id)
    field(:name, :string)
  end

  object :like do
    field(:id, :id)
    field(:slice_id, :integer)
  end

  object :like_result do
    field(:like, :like)
    field(:errors, list_of(:input_error))
  end
end
