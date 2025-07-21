defmodule SigncraftWeb.UserSettingsControllerTest do
  use SigncraftWeb.ConnCase, async: true

  alias Signcraft.Accounts
  import Signcraft.AccountsFixtures

  setup :register_and_log_in_user

  describe "GET /users/settings" do
    test "renders settings page", %{conn: conn} do
      conn = get(conn, ~p"/users/settings")
      response = html_response(conn, 200)
      assert response =~ "Settings"
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      conn = get(conn, ~p"/users/settings")
      assert redirected_to(conn) == ~p"/users/log_in"
    end
  end

  describe "PUT /users/settings (change password form)" do
    test "updates the user password and resets tokens", %{conn: conn, user: user} do
      new_password_conn =
        put(conn, ~p"/users/settings", %{
          "action" => "update_password",
          "current_password" => valid_user_password(),
          "user" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(new_password_conn) == ~p"/users/settings"

      assert get_session(new_password_conn, :user_token) != get_session(conn, :user_token)

      assert Phoenix.Flash.get(new_password_conn.assigns.flash, :info) =~
               "Password updated successfully"

      assert Accounts.get_user_by_username_and_password(user.username, "new valid password")
    end

    test "does not update password on invalid data", %{conn: conn} do
      old_password_conn =
        put(conn, ~p"/users/settings", %{
          "action" => "update_password",
          "current_password" => "invalid",
          "user" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(old_password_conn, 200)
      assert response =~ "Settings"
      assert response =~ "should be at least 12 character(s)"
      assert response =~ "does not match password"
      assert response =~ "is not valid"

      assert get_session(old_password_conn, :user_token) == get_session(conn, :user_token)
    end
  end

  describe "PUT /users/settings (change username form)" do
    @tag :capture_log
    test "updates the user username", %{conn: conn, user: user} do
      conn =
        put(conn, ~p"/users/settings", %{
          "action" => "update_username",
          "current_password" => valid_user_password(),
          "user" => %{"username" => unique_user_username()}
        })

      assert redirected_to(conn) == ~p"/users/settings"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "A link to confirm your username"

      assert Accounts.get_user_by_username(user.username)
    end

    test "does not update username on invalid data", %{conn: conn} do
      conn =
        put(conn, ~p"/users/settings", %{
          "action" => "update_username",
          "current_password" => "invalid",
          "user" => %{"username" => "with spaces"}
        })

      response = html_response(conn, 200)
      assert response =~ "Settings"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "is not valid"
    end
  end

  describe "GET /users/settings/confirm_username/:token" do
    setup %{user: user} do
      username = unique_user_username()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_update_username_instructions(%{user | username: username}, user.username, url)
        end)

      %{token: token, username: username}
    end

    test "updates the user username once", %{conn: conn, user: user, token: token, username: username} do
      conn = get(conn, ~p"/users/settings/confirm_username/#{token}")
      assert redirected_to(conn) == ~p"/users/settings"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "username changed successfully"

      refute Accounts.get_user_by_username(user.username)
      assert Accounts.get_user_by_username(username)

      conn = get(conn, ~p"/users/settings/confirm_username/#{token}")

      assert redirected_to(conn) == ~p"/users/settings"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "username change link is invalid or it has expired"
    end

    test "does not update username with invalid token", %{conn: conn, user: user} do
      conn = get(conn, ~p"/users/settings/confirm_username/oops")
      assert redirected_to(conn) == ~p"/users/settings"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "username change link is invalid or it has expired"

      assert Accounts.get_user_by_username(user.username)
    end

    test "redirects if user is not logged in", %{token: token} do
      conn = build_conn()
      conn = get(conn, ~p"/users/settings/confirm_username/#{token}")
      assert redirected_to(conn) == ~p"/users/log_in"
    end
  end
end
