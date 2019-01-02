defmodule Momento.Repo.Migrations.CreateTagsTable do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add(:name, :string)

      add :inserted_at, :naive_datetime, default: fragment("NOW()")
      add :updated_at, :naive_datetime, default: fragment("NOW()")
    end

    create(unique_index(:tags, [:name]))
  end
end
