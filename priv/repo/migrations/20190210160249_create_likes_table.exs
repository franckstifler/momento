defmodule Momento.Repo.Migrations.CreateLikesTable do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add(:user_id, references(:users), null: false)
      add(:slice_id, references(:slices), null: false)

      timestamps()
    end

    create unique_index(:likes, [:user_id, :slice_id])
  end
end
