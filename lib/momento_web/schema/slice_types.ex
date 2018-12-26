defmodule MomentoWeb.Schema.SliceTypes do
  use Absinthe.Schema.Notation
  alias MomentoWeb.Resolvers

  @desc "A slice of a video url"
  object :slice do
    field :id, :id
    field :start_time, :integer
    field :end_time, :integer
    field :video, :video do
      resolve &Resolvers.Media.get_slice_video/3
    end
    field :user, :user
    field :published_at, :naive_datetime
  end

  object :slice_result do
    field :slice, :slice
    field :errors, list_of(:input_error)
  end
end
