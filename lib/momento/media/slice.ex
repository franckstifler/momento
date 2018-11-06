defmodule Momento.Media.Slice do
  use Ecto.Schema
  import Ecto.Changeset


  schema "slices" do
    field :end_time, :integer
    field :start_time, :integer
    field :video_id, :id
    # field :user_id, :id

    belongs_to :user, Momento.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(slice, attrs) do
    slice
    |> cast(attrs, [:start_time, :end_time])
    |> validate_required([:start_time, :end_time])
  end
end
