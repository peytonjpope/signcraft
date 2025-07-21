defmodule Signcraft.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :text, :string
      add :is_system, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :word_type_id, references(:word_types, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:words, [:user_id])
    create index(:words, [:word_type_id])
  end
end
