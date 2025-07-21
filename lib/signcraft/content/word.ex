defmodule Signcraft.Content.Word do
  use Ecto.Schema
  import Ecto.Changeset

  schema "words" do
    field :text, :string
    field :is_system, :boolean, default: false
    belongs_to :user, Signcraft.Accounts.User
    belongs_to :word_type, Signcraft.Content.WordType

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(word, attrs, is_admin \\ false) do
    word
    |> cast(attrs, [:text, :user_id, :word_type_id])
    |> validate_required([:text, :user_id, :word_type_id])
    |> gloss_text()
    |> put_change(:is_system, is_admin)
    |> validate_length(:text, min: 1, max: 50)
  end

  # Trim whitespace and convert to uppercase
  defp gloss_text(changeset) do
    case get_change(changeset, :text) do
      nil -> changeset
      text when is_binary(text) ->
        normalized_text = text |> String.trim() |> String.upcase()
        put_change(changeset, :text, normalized_text)
      _ -> changeset
    end
  end

end
