defmodule Momento.Repo.Migrations.AddCommentTable do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:user_id, references(:users, on_delete: :delete_all), null: false)
      add(:slice_id, references(:slices, on_delete: :delete_all), null: false)
      add(:comment, :string, null: false)

      timestamps()
    end
  end
end
