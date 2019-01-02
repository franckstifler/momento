defmodule Momento.Media.Tag do
  use Ecto.Schema

  schema "tags" do
    field(:name)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)

    # many_to_many(:slices, join_through: "slices_tags", on_replace: :delete)
  end

  def parse_tags(tags) do
    tags
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
