defmodule Momento.Media.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias Momento.Media.{Answer, Slice}

  schema "questions" do
    field :text

    belongs_to(:slice, Slice)
    has_many(:answers, Answer)
    timestamps()
  end

  def changeset(question, attrs \\ %{}) do
    question
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> validate_length(:text, min: 3)
  end

end
