defmodule Signcraft.Content.Template do
  use Ecto.Schema
  import Ecto.Changeset

  schema "templates" do
    field :name, :string
    field :structure, {:array, :integer}
    field :is_system, :boolean, default: false
    belongs_to :user, Signcraft.Accounts.User


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(template, attrs, is_admin \\ false) do
    template
    |> cast(attrs, [:name, :structure, :user_id])
    |> validate_required([:name, :structure, :user_id])
    |> validate_length(:name, min: 1, max: 100)
    |> validate_structure()
    |> put_change(:is_system, is_admin)
  end

  defp validate_structure(changeset) do
    case get_change(changeset, :structure) do
      nil -> changeset
      [] -> add_error(changeset, :structure, "must have at least one word type")
      structure when is_list(structure) ->
        if length(structure) > 10 do
          add_error(changeset, :structure, "cannot have more than 10 word types")
        else
          changeset
        end
      _ -> add_error(changeset, :structure, "must be a list of word type IDs")
    end
  end
end
