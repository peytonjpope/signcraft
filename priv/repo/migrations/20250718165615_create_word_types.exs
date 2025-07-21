defmodule Signcraft.Repo.Migrations.CreateWordTypes do
  use Ecto.Migration

  def change do
    create table(:word_types) do
      add :name, :string
      add :is_system, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:word_types, [:user_id])
  end
end
