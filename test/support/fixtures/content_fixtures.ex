defmodule Signcraft.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Signcraft.Content` context.
  """

  @doc """
  Generate a word_type.
  """
  def word_type_fixture(attrs \\ %{}) do
    {:ok, word_type} =
      attrs
      |> Enum.into(%{
        is_system: true,
        name: "some name"
      })
      |> Signcraft.Content.create_word_type()

    word_type
  end

  @doc """
  Generate a word.
  """
  def word_fixture(attrs \\ %{}) do
    {:ok, word} =
      attrs
      |> Enum.into(%{
        is_system: true,
        text: "some text"
      })
      |> Signcraft.Content.create_word()

    word
  end

  @doc """
  Generate a template.
  """
  def template_fixture(attrs \\ %{}) do
    {:ok, template} =
      attrs
      |> Enum.into(%{
        is_system: true,
        name: "some name",
        structure: [1, 2]
      })
      |> Signcraft.Content.create_template()

    template
  end
end
