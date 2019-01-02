defmodule Momento.Repo.Migrations.CreateSlicesTagsTable do
  use Ecto.Migration

  def change do
    create table(:slices_tags, primary_key: false) do
      add :slice_id, references(:slices)
      add :tag_id, references(:tags)
    end
  end
end
