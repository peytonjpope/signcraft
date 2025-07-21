defmodule Signcraft.Repo.Migrations.AddAdminToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :admin, :boolean, default: false, null: false
      add :username, :string, null: false
      remove :username
    end

    create unique_index(:users, [:username])
  end
end
