defmodule Signcraft.SentenceGenerator do
  alias Signcraft.Content

  def random_sentence(user_id, is_admin) do
    # Get a random template for the user
    templates = Content.list_templates_for_user(user_id, is_admin)

    case templates do
      [] -> "No templates available"
      _ ->
        random_template = Enum.random(templates)

        # Generate words for each word type in the template structure
        sentence_words = Enum.map(random_template.structure, fn word_type_id ->
          # Get words of this type for the user
          words = Content.list_words_for_user(user_id, is_admin)
          |> Enum.filter(fn word -> word.word_type_id == word_type_id end)

          case words do
            [] -> "[missing]"
            available_words -> Enum.random(available_words).text
          end
        end)

        Enum.join(sentence_words, " ")
    end
  end
end
