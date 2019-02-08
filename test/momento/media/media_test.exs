defmodule Momento.MediaTest do
  use Momento.DataCase

  alias Momento.Media

  describe "videos" do
    alias Momento.Media.Video

    @valid_attrs %{url: "some url"}
    @update_attrs %{url: "some updated url"}
    @invalid_attrs %{url: nil}

    def video_fixture(attrs \\ %{}) do
      {:ok, video} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Media.create_video()

      video
    end

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert length(Media.list_videos()) >= 1
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Media.get_video(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      assert {:ok, %Video{} = video} = Media.create_video(@valid_attrs)
      assert video.url == "some url"
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      assert {:ok, video} = Media.update_video(video, @update_attrs)
      assert %Video{} = video
      assert video.url == "some updated url"
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_video(video, @invalid_attrs)
      assert video == Media.get_video(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Media.delete_video(video)
      assert is_nil(Media.get_video(video.id))
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Media.change_video(video)
    end
  end

  describe "slices" do
    alias Momento.Media.Slice

    @valid_attrs %{end_time: 50, start_time: 42, url: "youtube.com/test"}
    @update_attrs %{end_time: 53, start_time: 43, url: "youtube.com/test"}
    @invalid_attrs %{end_time: nil, start_time: nil, url: "nil"}
    @invalid_duration %{end_time: 10, start_time: 8, url: "youtube"}

    def slice_fixture(attrs \\ %{}) do
      attrs = Enum.into(attrs, @valid_attrs)
      {:ok, slice} = Media.create_slice(user_fixture(), attrs)

      slice
    end

    def user_fixture do
      {ok, user} =
        Momento.Accounts.create_user(%{username: "test", email: "test@mail.com", password: "test"})

      user
    end

    test "list_slices/0 returns all slices" do
      slice = slice_fixture()
      slices =
        Media.list_slices()
        |> Enum.map(&(Repo.preload(&1, [:video, :tags])))
      assert slices == [slice]
    end

    test "get_slice/1 returns the slice with given id" do
      slice = slice_fixture()

      new_slice =
        Media.get_slice(slice.id)
        |> Momento.Repo.preload([:video, :tags])

      assert new_slice == slice
    end

    test "create_slice/1 with valid data creates a slice" do
      user = user_fixture()
      assert {:ok, %Slice{} = slice} = Media.create_slice(user, @valid_attrs)
      assert slice.end_time == 50
      assert slice.start_time == 42
    end

    test "create_slice/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.create_slice(user, @invalid_attrs)
    end

    test "create_slice/1 with invalid duration returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.create_slice(user, @invalid_duration)
    end

    # test "update_slice/2 with valid data updates the slice" do
    #   slice = slice_fixture()
    #   user = user_fixture()
    #   assert {:ok, slice} = Media.update_slice(slice, @update_attrs)
    #   assert %Slice{} = slice
    #   assert slice.end_time == 53
    #   assert slice.start_time == 43
    # end

    test "update_slice/2 with invalid data returns error changeset" do
      # TODO: Implement update_slice
      # slice = slice_fixture()
      # assert {:error, %Ecto.Changeset{}} = Media.update_slice(slice, @invalid_attrs)
      # assert slice == Media.get_slice!(slice.id)
    end

    # test "delete_slice/1 deletes the slice" do
    #   slice = slice_fixture()
    #   assert {:ok, %Slice{}} = Media.delete_slice(slice)
    #   assert_raise Ecto.NoResultsError, fn -> Media.get_slice!(slice.id) end
    # end

    test "change_slice/1 returns a slice changeset" do
      slice = slice_fixture()
      assert %Ecto.Changeset{} = Media.change_slice(slice)
    end
  end
end
