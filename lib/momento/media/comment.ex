defmodule Momento.Media.Comment do

  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field(:comment, :string)

    belongs_to :user, Momento.Accounts.User
    belongs_to :slice, Momento.Media.Slice

    timestamps()
  end

  def changeset(comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:comment, :slice_id])
    |> validate_required([:comment, :slice_id])
    |> foreign_key_constraint(:slice_id)
  end
end
