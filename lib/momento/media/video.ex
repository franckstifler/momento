defmodule Momento.Media.Video do
  use Ecto.Schema
  import Ecto.Changeset


  schema "videos" do
    field :url, :string

    has_many(:slices, Momento.Media.Slice)

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> unique_constraint(:url)
  end
end
