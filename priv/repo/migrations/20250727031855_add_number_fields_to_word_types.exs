defmodule Signcraft.Repo.Migrations.AddNumberFieldsToWordTypes do
  use Ecto.Migration

  def change do
    alter table(:word_types) do
      add :is_number_type, :boolean, default: false
      add :number_min, :integer
      add :number_max, :integer
    end
  end
end
