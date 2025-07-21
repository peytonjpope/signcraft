defmodule SigncraftWeb.UserRegistrationController do
  use SigncraftWeb, :controller

  alias Signcraft.Accounts
  alias Signcraft.Accounts.User
  alias SigncraftWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        # Set up user content after successful registration
        case Signcraft.Content.setup_user_content(user.id) do
          {:ok, _} ->
            conn
            |> put_flash(:info, "Account created! Check out the starter content we've set up for you.")
            |> UserAuth.log_in_user(user)

          {:error, _reason} ->
            conn
            |> put_flash(:error, "Account created but failed to set up starter content.")
            |> UserAuth.log_in_user(user)
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
