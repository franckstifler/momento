defmodule Momento.Media do
  @moduledoc """
  The Media context.
  """

  import Ecto.Query, warn: false
  alias Momento.Repo

  alias Momento.Media.Video

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos do
    Repo.all(Video)
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id), do: Repo.get!(Video, id)

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(attrs \\ %{}) do
    %Video{}
    |> Video.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end

  alias Momento.Media.Slice

  @doc """
  Returns the list of slices.

  ## Examples

      iex> list_slices()
      [%Slice{}, ...]

  """
  def list_slices do
    Repo.all(Slice)
  end

  def list_slices(user, %{date: date}) do
    from(
      t in Slice,
      where: t.user_id == ^user.id,
      where: fragment("date_trunc('day', ?)", t.inserted_at) == type(^date, :date)
    )
    |> Repo.all()
  end

  def list_slices(user, _) do
    from(
      t in Slice,
      where: t.user_id == ^user.id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single slice.

  Raises `Ecto.NoResultsError` if the Slice does not exist.

  ## Examples

      iex> get_slice!(123)
      %Slice{}

      iex> get_slice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_slice!(id), do: Repo.get!(Slice, id)

  @doc """
  Creates a slice.

  ## Examples

      iex> create_slice(%{field: value})
      {:ok, %Slice{}}

      iex> create_slice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_slice(user, attrs \\ %{}) do
    %Slice{}
    |> Slice.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Repo.insert()
  end

  @doc """
  Updates a slice.

  ## Examples

      iex> update_slice(slice, %{field: new_value})
      {:ok, %Slice{}}

      iex> update_slice(slice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_slice(%Slice{} = slice, attrs) do
    slice
    |> Slice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Slice.

  ## Examples

      iex> delete_slice(slice)
      {:ok, %Slice{}}

      iex> delete_slice(slice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_slice(%Slice{} = slice) do
    Repo.delete(slice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking slice changes.

  ## Examples

      iex> change_slice(slice)
      %Ecto.Changeset{source: %Slice{}}

  """
  def change_slice(%Slice{} = slice) do
    Slice.changeset(slice, %{})
  end
end