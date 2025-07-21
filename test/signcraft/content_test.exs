defmodule Signcraft.ContentTest do
  use Signcraft.DataCase

  alias Signcraft.Content

  describe "word_types" do
    alias Signcraft.Content.WordType

    import Signcraft.ContentFixtures

    @invalid_attrs %{name: nil, is_system: nil}

    test "list_word_types/0 returns all word_types" do
      word_type = word_type_fixture()
      assert Content.list_word_types() == [word_type]
    end

    test "get_word_type!/1 returns the word_type with given id" do
      word_type = word_type_fixture()
      assert Content.get_word_type!(word_type.id) == word_type
    end

    test "create_word_type/1 with valid data creates a word_type" do
      valid_attrs = %{name: "some name", is_system: true}

      assert {:ok, %WordType{} = word_type} = Content.create_word_type(valid_attrs)
      assert word_type.name == "some name"
      assert word_type.is_system == true
    end

    test "create_word_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_word_type(@invalid_attrs)
    end

    test "update_word_type/2 with valid data updates the word_type" do
      word_type = word_type_fixture()
      update_attrs = %{name: "some updated name", is_system: false}

      assert {:ok, %WordType{} = word_type} = Content.update_word_type(word_type, update_attrs)
      assert word_type.name == "some updated name"
      assert word_type.is_system == false
    end

    test "update_word_type/2 with invalid data returns error changeset" do
      word_type = word_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_word_type(word_type, @invalid_attrs)
      assert word_type == Content.get_word_type!(word_type.id)
    end

    test "delete_word_type/1 deletes the word_type" do
      word_type = word_type_fixture()
      assert {:ok, %WordType{}} = Content.delete_word_type(word_type)
      assert_raise Ecto.NoResultsError, fn -> Content.get_word_type!(word_type.id) end
    end

    test "change_word_type/1 returns a word_type changeset" do
      word_type = word_type_fixture()
      assert %Ecto.Changeset{} = Content.change_word_type(word_type)
    end
  end

  describe "words" do
    alias Signcraft.Content.Word

    import Signcraft.ContentFixtures

    @invalid_attrs %{text: nil, is_system: nil}

    test "list_words/0 returns all words" do
      word = word_fixture()
      assert Content.list_words() == [word]
    end

    test "get_word!/1 returns the word with given id" do
      word = word_fixture()
      assert Content.get_word!(word.id) == word
    end

    test "create_word/1 with valid data creates a word" do
      valid_attrs = %{text: "some text", is_system: true}

      assert {:ok, %Word{} = word} = Content.create_word(valid_attrs)
      assert word.text == "some text"
      assert word.is_system == true
    end

    test "create_word/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_word(@invalid_attrs)
    end

    test "update_word/2 with valid data updates the word" do
      word = word_fixture()
      update_attrs = %{text: "some updated text", is_system: false}

      assert {:ok, %Word{} = word} = Content.update_word(word, update_attrs)
      assert word.text == "some updated text"
      assert word.is_system == false
    end

    test "update_word/2 with invalid data returns error changeset" do
      word = word_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_word(word, @invalid_attrs)
      assert word == Content.get_word!(word.id)
    end

    test "delete_word/1 deletes the word" do
      word = word_fixture()
      assert {:ok, %Word{}} = Content.delete_word(word)
      assert_raise Ecto.NoResultsError, fn -> Content.get_word!(word.id) end
    end

    test "change_word/1 returns a word changeset" do
      word = word_fixture()
      assert %Ecto.Changeset{} = Content.change_word(word)
    end
  end

  describe "templates" do
    alias Signcraft.Content.Template

    import Signcraft.ContentFixtures

    @invalid_attrs %{name: nil, structure: nil, is_system: nil}

    test "list_templates/0 returns all templates" do
      template = template_fixture()
      assert Content.list_templates() == [template]
    end

    test "get_template!/1 returns the template with given id" do
      template = template_fixture()
      assert Content.get_template!(template.id) == template
    end

    test "create_template/1 with valid data creates a template" do
      valid_attrs = %{name: "some name", structure: [1, 2], is_system: true}

      assert {:ok, %Template{} = template} = Content.create_template(valid_attrs)
      assert template.name == "some name"
      assert template.structure == [1, 2]
      assert template.is_system == true
    end

    test "create_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_template(@invalid_attrs)
    end

    test "update_template/2 with valid data updates the template" do
      template = template_fixture()
      update_attrs = %{name: "some updated name", structure: [1], is_system: false}

      assert {:ok, %Template{} = template} = Content.update_template(template, update_attrs)
      assert template.name == "some updated name"
      assert template.structure == [1]
      assert template.is_system == false
    end

    test "update_template/2 with invalid data returns error changeset" do
      template = template_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_template(template, @invalid_attrs)
      assert template == Content.get_template!(template.id)
    end

    test "delete_template/1 deletes the template" do
      template = template_fixture()
      assert {:ok, %Template{}} = Content.delete_template(template)
      assert_raise Ecto.NoResultsError, fn -> Content.get_template!(template.id) end
    end

    test "change_template/1 returns a template changeset" do
      template = template_fixture()
      assert %Ecto.Changeset{} = Content.change_template(template)
    end
  end
end
