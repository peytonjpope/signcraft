defmodule Signcraft.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Signcraft.Repo

  alias Signcraft.Accounts.{User, UserToken, UserNotifier}

  alias Signcraft.Content.{WordType, Word, Template}

  ## Database getters

  @doc """
  Gets a user by username.

  ## Examples

      iex> get_user_by_username("foo@example.com")
      %User{}

      iex> get_user_by_username("unknown@example.com")
      nil

  """
  def get_user_by_username(username) when is_binary(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  Gets a user by username and password.

  ## Examples

      iex> get_user_by_username_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_username_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_username_and_password(username, password)
      when is_binary(username) and is_binary(password) do
    user = Repo.get_by(User, username: username)
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false, validate_username: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user username.

  ## Examples

      iex> change_user_username(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_username(user, attrs \\ %{}) do
    User.username_changeset(user, attrs, validate_username: false)
  end

  @doc """
  Emulates that the username will change without actually changing
  it in the database.

  ## Examples

      iex> apply_user_username(user, "valid password", %{username: ...})
      {:ok, %User{}}

      iex> apply_user_username(user, "invalid password", %{username: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_user_username(user, password, attrs) do
    user
    |> User.username_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user username using the given token.

  If the token matches, the user username is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_username(user, token) do
    context = "change:#{user.username}"

    with {:ok, query} <- UserToken.verify_change_username_token_query(token, context),
         %UserToken{sent_to: username} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_username_multi(user, username, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_username_multi(user, username, context) do
    changeset =
      user
      |> User.username_changeset(%{username: username})
      |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, [context]))
  end

  @doc ~S"""
  Delivers the update username instructions to the given user.

  ## Examples

      iex> deliver_user_update_username_instructions(user, current_username, &url(~p"/users/settings/confirm_username/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_update_username_instructions(%User{} = user, current_username, update_username_url_fun)
      when is_function(update_username_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_username_token(user, "change:#{current_username}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_username_instructions(user, update_username_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation
  @doc """
  removed
  """

end
