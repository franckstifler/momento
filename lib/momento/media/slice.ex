defmodule Momento.Media.Slice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "slices" do
    field(:end_time, :integer)
    field(:start_time, :integer)
    # field :video_id, :id
    # field :user_id, :id

    belongs_to(:user, Momento.Accounts.User)
    belongs_to(:video, Momento.Media.Video)

    timestamps()
  end

  @doc false
  def changeset(slice, attrs) do
    slice
    |> cast(attrs, [:start_time, :end_time])
    |> validate_required([:start_time, :end_time])
    |> check_length()
  end

  @min_time 3
  @max_time 10
  defp check_length(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{start_time: stime, end_time: etime}} ->
        case etime - stime do
          time when time >= @min_time and time <= @max_time ->
            changeset

          time when time > @max_time ->
            add_error(changeset, :time, "The duration of a slice is maximum: #{@max_time}s")

          time when time < @min_time ->
            add_error(changeset, :time, "The duration of a slice is minimum: #{@min_time}s")

          _ ->
            add_error(changeset, :time, "Invalid duration of video")
        end

      _ ->
        changeset
    end
  end
end
