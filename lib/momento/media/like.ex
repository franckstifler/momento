defmodule Momento.Media.Like do
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    belongs_to(:user, Momento.Accounts.User)
    belongs_to(:slice, Momento.Media.Slice)

    timestamps()
  end

  def changeset(like, attrs \\ %{}) do
    like
    |> cast(attrs, [:slice_id])
    |> unique_constraint(:like, name: :likes_user_id_slice_id_index, message: "already liked")
  end
end
