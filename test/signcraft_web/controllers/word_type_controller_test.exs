defmodule SigncraftWeb.WordTypeControllerTest do
  use SigncraftWeb.ConnCase

  import Signcraft.ContentFixtures

  @create_attrs %{name: "some name", is_system: true}
  @update_attrs %{name: "some updated name", is_system: false}
  @invalid_attrs %{name: nil, is_system: nil}

  describe "index" do
    test "lists all word_types", %{conn: conn} do
      conn = get(conn, ~p"/word_types")
      assert html_response(conn, 200) =~ "Listing Word types"
    end
  end

  describe "new word_type" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/word_types/new")
      assert html_response(conn, 200) =~ "New Word type"
    end
  end

  describe "create word_type" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/word_types", word_type: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/word_types/#{id}"

      conn = get(conn, ~p"/word_types/#{id}")
      assert html_response(conn, 200) =~ "Word type #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/word_types", word_type: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Word type"
    end
  end

  describe "edit word_type" do
    setup [:create_word_type]

    test "renders form for editing chosen word_type", %{conn: conn, word_type: word_type} do
      conn = get(conn, ~p"/word_types/#{word_type}/edit")
      assert html_response(conn, 200) =~ "Edit Word type"
    end
  end

  describe "update word_type" do
    setup [:create_word_type]

    test "redirects when data is valid", %{conn: conn, word_type: word_type} do
      conn = put(conn, ~p"/word_types/#{word_type}", word_type: @update_attrs)
      assert redirected_to(conn) == ~p"/word_types/#{word_type}"

      conn = get(conn, ~p"/word_types/#{word_type}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, word_type: word_type} do
      conn = put(conn, ~p"/word_types/#{word_type}", word_type: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Word type"
    end
  end

  describe "delete word_type" do
    setup [:create_word_type]

    test "deletes chosen word_type", %{conn: conn, word_type: word_type} do
      conn = delete(conn, ~p"/word_types/#{word_type}")
      assert redirected_to(conn) == ~p"/word_types"

      assert_error_sent 404, fn ->
        get(conn, ~p"/word_types/#{word_type}")
      end
    end
  end

  defp create_word_type(_) do
    word_type = word_type_fixture()
    %{word_type: word_type}
  end
end
