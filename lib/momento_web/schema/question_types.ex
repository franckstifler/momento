defmodule MomentoWeb.Schema.QuestionTypes do
  use Absinthe.Schema.Notation
  # alias Absinthe.Resolution.Helpers


  input_object :question do
    field(:id, :id)
    field(:text, :string)
    field(:answers, list_of(:answer))
  end

  input_object :answer do
    field(:text, :string)
    field(:is_correct, :boolean)
  end

  # object :user_result do
  #   field(:errors, list_of(:input_error))
  #   field(:question, :question)
  # end
end
