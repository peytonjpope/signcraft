defmodule Signcraft.Repo.Migrations.AddUniqueConstraintsAllEntities do
  use Ecto.Migration

  def change do
    # WordType: unique name per user
    create unique_index(:word_types, [:user_id, :name],
                       name: :word_types_user_id_name_index)

    # Word: unique text per user
    create unique_index(:words, [:user_id, :text],
                       name: :words_user_id_text_index)

    # Template: unique structure per user
    create unique_index(:templates, [:user_id, :structure],
                        name: :templates_user_id_structure_index)
  end
end
