defmodule Momento.Repo.Migrations.CreateQuestionsTable do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add(:text, :string, null: false)
      add(:slice_id, references(:slices, null: false, on_delete: :delete_all))
      timestamps()
    end
    create(unique_index(:questions, [:slice_id]))
  end
end
