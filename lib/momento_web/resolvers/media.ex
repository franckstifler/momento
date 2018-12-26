defmodule MomentoWeb.Resolvers.Media do
  def list_slices(%Momento.Accounts.User{} = author, args, _resolution) do
    {:ok, Momento.Media.list_slices(author, args)}
  end

  def list_slices(_parent, _args, _resolution) do
    {:ok, Momento.Media.list_slices()}
  end

  def create_slice(_parent, args, %{context: context}) do
    case context do
      %{current_user: user} ->
        with {:ok, slice} <- Momento.Media.create_slice(user, args) do
          {:ok, %{slice: slice}}
        end

      _ ->
        {:error, "unauthorized"}
    end
  end

  def get_slice_video(%Momento.Media.Slice{video_id: id}, _attrs, _) do
    video = Momento.Media.get_video(id)
    {:ok, video}
  end
end
