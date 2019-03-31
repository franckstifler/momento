defmodule Momento.Repo.Migrations.AddTitleToSlice do
  use Ecto.Migration

  def up do
    alter table "slices" do
      add(:title, :string, null: false)
    end

    create(index(:slices, [:title]))
  end

  def down do
    alter table "slices" do
      remove(:title)
      drop(index(:slices, [:title]))
    end
  end
end
