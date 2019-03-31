defmodule Momento.Media.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :text, :string
    field :is_correct, :boolean

    belongs_to(:question, Momento.Media.Question)
    timestamps()
  end

  def changeset(question, attrs \\ %{}) do
    question
    |> cast(attrs, [:text, :is_correct])
    |> validate_required([:text, :is_correct])
  end

  def verify_answers_length(%Ecto.Changeset{valid?: true, changes: _changes} = changeset) do
    validate_length(changeset, :answers, min: 2, max: 4)
  end

  def verify_answers_length(changeset), do: changeset

  def verify_single_correct_answer(%Ecto.Changeset{valid?: true, changes: changes} = changeset) do
    count = Enum.count(changes.answers, fn answer ->
      answer.changes.is_correct
    end)

    case count do
      1 ->
        changeset
      _ ->
        add_error(changeset, :answers, "Provide a single right answer")
    end
  end

  def verify_single_correct_answer(changeset), do: changeset
end
