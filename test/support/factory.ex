defmodule Factory do

  alias Momento.Repo

  def create_user() do
    int = :erlang.unique_integer([:positive, :monotonic])
    params = %{
      username: "Person #{int}",
      email: "fake-#{int}@example.com",
      password: "super-secret",
    }

    %Momento.Accounts.User{}
    |> Momento.Accounts.User.changeset(params)
    |> Repo.insert!
  end

  alias Momento.Media.{Video, Slice}

  def create_video do
    %Video{}
    |> Video.changeset(%{url: "www.youtube.com/test"})
    |> Repo.insert!
  end

  def create_slice do
    video = Factory.create_video()
    user = Factory.create_user()
    int = :erlang.unique_integer([:positive, :monotonic])
    params = %{
      title: "A title #{int}",
      start_time: 10,
      end_time: 15,
      user_id: user.id,
      video_id: video.id
    }
    %Slice{}
    |> Slice.changeset(params)
    |> Repo.insert!
  end
end
