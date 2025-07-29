defmodule SigncraftWeb.WordController do
  use SigncraftWeb, :controller

  alias Signcraft.Content
  alias Signcraft.Content.Word

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    is_admin = conn.assigns.current_user.admin

    word_types = Content.list_word_types_for_user(user_id, is_admin)
    |> Enum.filter(fn word_type -> not word_type.is_number_type end)

    words = Content.list_words_for_current_user(user_id, is_admin)
    render(conn, :index, words: words, word_types: word_types)
  end

  def new(conn, _params) do
    changeset = Content.change_word(%Word{})
    user_id = conn.assigns.current_user.id
    is_admin = conn.assigns.current_user.admin

    word_types = Content.list_word_types_for_user(user_id, is_admin)
    |> Enum.filter(fn word_type -> not word_type.is_number_type end)

    render(conn, :new, changeset: changeset, word_types: word_types)
  end

  def create(conn, %{"word" => word_params}) do
    word_params = Map.put(word_params, "user_id", conn.assigns.current_user.id)
    is_admin = conn.assigns.current_user.admin

    case Content.create_word(word_params, is_admin) do  # <- Add is_admin here
      {:ok, word} ->
        conn
        |> put_flash(:info, "Word '#{word.text}' added successfully!")
        |> redirect(to: ~p"/words")

      {:error, %Ecto.Changeset{} = changeset} ->
        user_id = conn.assigns.current_user.id
        is_admin = conn.assigns.current_user.admin
        word_types = Content.list_word_types_for_user(user_id, is_admin)
        render(conn, :new, changeset: changeset, word_types: word_types)  # <- Add word_types here
    end
  end

  def show(conn, %{"id" => id}) do
    word = Content.get_word!(id)

    render(conn, :show, word: word)
  end

  def edit(conn, %{"id" => id}) do
    word = Content.get_word!(id)
    changeset = Content.change_word(word)
    is_admin = conn.assigns.current_user.admin
    user_id = conn.assigns.current_user.id
    word_types = Content.list_word_types_for_user(user_id, is_admin)
    |> Enum.filter(fn word_type -> not word_type.is_number_type end)

    render(conn, :edit, word: word, changeset: changeset, word_types: word_types)

  end

  def update(conn, %{"id" => id, "word" => word_params}) do
    word = Content.get_word!(id)
    user_id = conn.assigns.current_user.id
    is_admin = conn.assigns.current_user.admin

    case Content.update_word(word, word_params, is_admin) do
      {:ok, word} ->
        conn
        |> put_flash(:info, "Word updated successfully.")
        |> redirect(to: ~p"/words/#{word}")

      {:error, %Ecto.Changeset{} = changeset} ->
        word_types = Content.list_word_types_for_user(user_id, is_admin)
        render(conn, :edit, word: word, changeset: changeset, word_types: word_types)
    end
  end

  def delete(conn, %{"id" => id}) do
    word = Content.get_word!(id)
    {:ok, _word} = Content.delete_word(word)

    conn
    |> put_flash(:info, "Word deleted successfully.")
    |> redirect(to: ~p"/words")
  end
end
