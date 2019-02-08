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
    case context do
      %{current_user: user} ->
        with {:ok, slice} <- Media.create_slice(user, args) do
          {:ok, %{slice: slice}}
        end

      _ ->
        {:error, "unauthorized"}
    end
  end

  def get_slice_video(%Media.Slice{video_id: id}, _attrs, _) do
    video = Media.get_video(id)
    {:ok, video}
  end

  def create_comment(_parent, args, %{context: context}) do
    case context do
      %{current_user: user} ->
        with {:ok, comment} <- Media.create_comment(user, args) do
          {:ok, %{comment: comment}}
        end
      _ ->
        {:error, "unauthorized"}
    end
  end
end
