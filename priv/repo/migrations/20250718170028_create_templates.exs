defmodule Signcraft.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :name, :string
      add :structure, {:array, :integer}
      add :is_system, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:templates, [:user_id])
  end
end
