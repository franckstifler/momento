defmodule Momento.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :url, :string

      timestamps()
    end

    create unique_index(:videos, [:url])
  end
end
