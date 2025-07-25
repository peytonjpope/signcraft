defmodule SigncraftWeb.WordTypeController do
  use SigncraftWeb, :controller

  alias Signcraft.Content
  alias Signcraft.Content.WordType
  alias Ecto.Changeset

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    is_admin = conn.assigns.current_user.admin

    word_types = Content.list_word_types_for_user(user_id, is_admin)
    render(conn, :index, word_types: word_types)
  end

  def new(conn, _params) do
    changeset = Content.change_word_type(%WordType{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"word_type" => word_type_params}) do
    word_type_params = Map.put(word_type_params, "user_id", conn.assigns.current_user.id)
    is_admin = conn.assigns.current_user.admin

    case Content.create_word_type(word_type_params, is_admin) do
      {:ok, word_type} ->
        conn
        |> put_flash(:info, "Word type '#{word_type.name}' created successfully!")
        |> redirect(to: ~p"/word_types")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    word_type = Content.get_word_type!(id)
    render(conn, :show, word_type: word_type)
  end

  def edit(conn, %{"id" => id}) do
    word_type = Content.get_word_type!(id)
    changeset = Content.change_word_type(word_type)
    render(conn, :edit, word_type: word_type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "word_type" => word_type_params}) do
    word_type = Content.get_word_type!(id)
    is_admin = conn.assigns.current_user.admin

    case Content.update_word_type(word_type, word_type_params, is_admin) do
      {:ok, word_type} ->
        conn
        |> put_flash(:info, "Word type updated successfully.")
        |> redirect(to: ~p"/word_types/#{word_type}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, word_type: word_type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    word_type = Content.get_word_type!(id)

    case Content.delete_word_type(word_type) do
      {:ok, %WordType{name: name}} ->
        conn
        |> put_flash(:info, "Word type deleted successfully.")
        |> redirect(to: ~p"/word_types")

      {:error, %Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Cannot delete type belonging to associated word(s) or templates.")
        |> redirect(to: ~p"/word_types")
    end
  end
end
