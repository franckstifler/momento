defmodule MomentoWeb.Resolvers.Media do
  # import Absinthe.Resolution.Helpers, only: [on_load: 2]
  alias Momento.{Accounts, Media}

  def list_slices(%Accounts.User{} = author, args, _resolution) do
    {:ok, Media.list_slices(author, args)}
  end

  def list_slices(_parent, _args, _resolution) do
    {:ok, Media.list_slices()}
  end

  def find_slice(_parent, %{id: id}, _resolution) do
    {:ok, Media.get_slice(id)}
  end

  def create_slice(_parent, args, %{context: context}) do
    with {:ok, slice} <- Media.create_slice(context.current_user, args) do
      {:ok, %{slice: slice}}
    end
  end

  def get_slice_video(%Media.Slice{video_id: id}, _attrs, _) do
    video = Media.get_video(id)
    {:ok, video}
  end

  def create_comment(_parent, args, %{context: context}) do
    with {:ok, comment} <- Media.create_comment(context.current_user, args) do
      {:ok, %{comment: comment}}
    end
  end

  def delete_comment(_parent, args, %{context: context}) do
    with comment <- Media.get_comment(context.current_user, args.comment_id),
         {:ok, comment} <- Media.delete_comment(comment) do
      {:ok, %{comment: comment}}
    end
  end

  def create_like(_parent, args, %{context: context}) do
    with {:ok, like} <- Media.create_like(context.current_user, args) do
      {:ok, %{like: like}}
    end
  end

  def delete_like(_parent, args, %{context: context}) do
    with like <-
           Media.get_like_by_user_and_slice(context.current_user, Map.get(args, :slice_id, "")),
         {:ok, like} <- Media.delete_like(like) do
      {:ok, %{like: like}}
    end
  end
end
