defmodule MomentoWeb.Schema.VideoTypes do
  use Absinthe.Schema.Notation

  @desc "A video of the site"
  object :video do
    field :id, :id
    field :url, :string

    field :slices, list_of(:slice)
  end
end
