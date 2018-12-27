defmodule MomentoWeb.Schema.SliceTypes do
  alias Absinthe.Resolution.Helpers
  use Absinthe.Schema.Notation

  @desc "A slice of a video url"
  object :slice do
    field(:id, :id)
    field(:start_time, :integer)
    field(:end_time, :integer)
    field(:video, :video, resolve: Helpers.dataloader(Momento.Media))
    field(:user, :user)
    field(:published_at, :naive_datetime)
  end

  object :slice_result do
    field(:slice, :slice)
    field(:errors, list_of(:input_error))
  end
end
