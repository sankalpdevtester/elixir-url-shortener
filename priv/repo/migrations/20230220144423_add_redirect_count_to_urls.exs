defmodule ElixirUrlShortener.Repo.Migrations.AddRedirectCountToUrls do
  use Ecto.Migration

  def change do
    alter table(:urls) do
      add :redirect_count, :integer, default: 0
    end
  end
end