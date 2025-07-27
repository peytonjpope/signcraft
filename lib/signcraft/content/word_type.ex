defmodule Signcraft.Content.WordType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "word_types" do
    field :name, :string
    field :is_system, :boolean, default: false
    field :is_number_type, :boolean, default: false
    field :number_min, :integer
    field :number_max, :integer
    belongs_to :user, Signcraft.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(word_type, attrs, is_admin \\ false) do
    word_type
    |> cast(attrs, [:name, :user_id, :is_number_type, :number_min, :number_max])
    |> validate_required([:name, :user_id])
    |> type_text_formate()
    |> put_change(:is_system, is_admin)
    |> validate_length(:name, min: 1, max: 50)
    |> validate_number_type_fields()
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

  # Validate number type specific fields
  defp validate_number_type_fields(changeset) do
    is_number_type = get_field(changeset, :is_number_type)

    if is_number_type do
      changeset
      |> validate_required([:number_min, :number_max], message: "required for number types")
      |> validate_number(:number_min, greater_than: 0)
      |> validate_number(:number_max, greater_than: 0)
      |> validate_min_less_than_max()
    else
      # Clear number fields if not a number type
      changeset
      |> put_change(:number_min, nil)
      |> put_change(:number_max, nil)
    end
  end

  defp validate_min_less_than_max(changeset) do
    min = get_field(changeset, :number_min)
    max = get_field(changeset, :number_max)

    if min && max && min >= max do
      add_error(changeset, :number_max, "must be greater than minimum")
    else
      changeset
    end
  end
end
