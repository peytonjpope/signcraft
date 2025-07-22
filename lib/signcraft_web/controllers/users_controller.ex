defmodule SigncraftWeb.UsersController do
  use SigncraftWeb, :controller


  alias Signcraft.Accounts

  def index(conn, _params) do
    if conn.assigns.current_user.admin do
      users = Accounts.list_users()

      users_with_counts = Enum.map(users, fn user ->
        user_words = Signcraft.Content.list_words_for_user(user.id)
        word_count = length(user_words)
        Map.put(user, :word_count, word_count)
      end)
      |> Enum.sort_by(& &1.word_count, :desc)  # Sort by word count, highest first

      render(conn, :index, users: users_with_counts)
    else
      conn
      |> put_flash(:error, "You are not authorized to view this page.")
      |> redirect(to: ~p"/")
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    user_words = Signcraft.Content.list_words_for_user(id)
    user_word_count = length(user_words)

    if conn.assigns.current_user.admin or conn.assigns.current_user.id == user.id do
      render(conn, :show, user: user, user_words: user_words, user_word_count: user_word_count)
    else
      conn
      |> put_flash(:error, "You are not authorized to view this page.")
      |> redirect(to: ~p"/")  # Changed from Routes.page_path
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    current_user = conn.assigns.current_user

    cond do
      # Admin can delete any user except themselves
      current_user.admin and current_user.id != user.id ->
        {:ok, _user} = Accounts.delete_user(user)
        conn
        |> put_flash(:info, "User deleted successfully.")
        |> redirect(to: ~p"/users")

      # Users can delete their own account
      current_user.id == user.id ->
        {:ok, _user} = Accounts.delete_user(user)
        conn
        |> put_flash(:info, "Your account has been deleted.")
        |> redirect(to: ~p"/")

      # Not authorized
      true ->
        conn
        |> put_flash(:error, "You are not authorized to delete this user.")
        |> redirect(to: ~p"/")
    end
  end

end
