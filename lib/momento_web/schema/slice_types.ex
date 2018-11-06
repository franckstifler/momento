defmodule MomentoWeb.Schema.SliceTypes do
  use Absinthe.Schema.Notation

  @desc "A slice of a video url"
  object :slice do
    field :id, :id
    field :start_time, :integer
    field :end_time, :integer
    field :video, :video
    field :user, :user
    field :published_at, :naive_datetime
  end
end
