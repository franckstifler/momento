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
        Momento.Media.create_slice(user, args)

      _ ->
        {:error, "unauthorized"}
    end
  end

  def get_slice_video(%Momento.Media.Slice{video_id: id}, _attrs, _) do
    IO.inspect id
    video = Momento.Media.get_video(id)
    {:ok, video}
  end
end
