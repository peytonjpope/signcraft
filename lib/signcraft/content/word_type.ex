defmodule Signcraft.Content.WordType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "word_types" do
    field :name, :string
    field :is_system, :boolean, default: false
    belongs_to :user, Signcraft.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(word_type, attrs, is_admin \\ false) do
    word_type
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> type_text_formate()
    |> put_change(:is_system, is_admin)
    |> validate_length(:name, min: 1, max: 50)
    |> unique_constraint(:name,
      name: :word_types_user_id_name_index,
      message: "You already have a word type with this name")
  end

  # Trim whitespace and convert to lowercase
  defp type_text_formate(changeset) do
    case get_change(changeset, :name) do
      nil -> changeset
      name when is_binary(name) ->
        normalized_name = name |> String.trim() |> String.downcase()
        put_change(changeset, :name, normalized_name)
      _ -> changeset
    end
  end
end
