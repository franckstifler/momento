defmodule Momento.Media do
  @moduledoc """
  The Media context.
  """

  import Ecto.Query, warn: false
  alias Momento.Repo

  alias Momento.Media.Video

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end

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
  def get_video(id), do: Repo.get(Video, id)

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

  alias Momento.Media.{Slice, Tag}

  @doc """
  Returns the list of slices.

  ## Examples

      iex> list_slices()
      [%Slice{}, ...]

  """
  def list_slices do
    query =
      from(
        s in Slice,
        left_join: l in assoc(s, :likes),
        group_by: s.id,
        select: %{s | likes: count(l.id)}
      )

    Repo.all(query)
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

  ## Examples

      iex> get_slice(123)
      %Slice{}

      iex> get_slice(456)
      ** nil

  """
  def get_slice(id) do
    query =
      from(
        s in Slice,
        where: [id: ^id],
        left_join: l in assoc(s, :likes),
        group_by: s.id,
        select: %{s | likes: count(l.id)}
      )

    Repo.one(query)
  end

  @doc """
  Creates a slice.

  ## Examples

      iex> create_slice(%{field: value})
      {:ok, %Slice{}}

      iex> create_slice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_slice(user, attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:video, &insert_and_get_video(&1, attrs))
    |> Ecto.Multi.run(:tags, &insert_and_get_all_tags(&1, attrs))
    |> Ecto.Multi.run(:slice, &insert_slice(&1, user, attrs))
    |> Repo.transaction()
    |> case do
      {:error, _name, failed_changes, _changes_so_far} ->
        {:error, failed_changes}

      {:ok, changes} ->
        {:ok, changes.slice}
    end
  end

  defp insert_and_get_video(_changes, params) do
    case Repo.get_by(Video, url: Map.get(params, :url, "")) do
      nil ->
        create_video(params)

      video ->
        {:ok, video}
    end
  end

  defp insert_and_get_all_tags(_changes, params) do
    case Tag.parse_tags(Map.get(params, :tags, "")) do
      [] ->
        {:ok, []}

      tags ->
        maps =
          Enum.map(
            tags,
            &%{name: &1, updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)}
          )

        Repo.insert_all(Tag, maps, on_conflict: :nothing)
        {:ok, Repo.all(from(t in Tag, where: t.name in ^tags))}
    end
  end

  defp insert_slice(%{video: video, tags: tags}, user, params) do
    changeset =
      Slice.changeset(%Slice{}, params)
      |> Ecto.Changeset.put_assoc(:tags, tags)
      |> Ecto.Changeset.put_assoc(:video, video)
      |> Ecto.Changeset.put_change(:user_id, user.id)

    Repo.insert(changeset)
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

  alias Momento.Media.Comment

  def get_comment(user, slice_id) do
    Repo.get_by(Comment, user_id: user.id, slice_id: slice_id)
  end

  def create_comment(user, attrs) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Repo.insert()
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(Comment, comment)
  end

  alias Momento.Media.Like

  def get_like_by_user_and_slice(user, slice_id) do
    Repo.get_by(Like, user_id: user.id, slice_id: slice_id)
  end

  def create_like(user, attrs) do
    %Like{}
    |> Like.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Repo.insert()
  end

  def delete_like(%Like{} = like) do
    Repo.delete(like)
  end

  def delete_like(_) do
    {:error, "Like not found"}
  end
end
