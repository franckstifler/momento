defmodule Momento.Repo.Migrations.CreateSlices do
  use Ecto.Migration

  def change do
    create table(:slices) do
      add :start_time, :integer
      add :end_time, :integer
      add :video_id, references(:videos, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:slices, [:video_id])
    create index(:slices, [:user_id])
  end
end
