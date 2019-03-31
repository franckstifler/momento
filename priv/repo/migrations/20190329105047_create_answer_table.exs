defmodule Momento.Repo.Migrations.CreateAnswerTable do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add(:text, :string, null: false)
      add(:is_correct, :boolean, null: false, default: false)
      add(:question_id, references(:questions, null: false, on_delete: :delete_all))
      timestamps()
    end
  end
end
