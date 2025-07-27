defmodule Signcraft.SentenceGenerator do
  alias Signcraft.Content

  # Original random sentence (no targeting)
  def random_sentence(user_id, is_admin) do
    templates = Content.list_templates_for_user(user_id, is_admin)

    case templates do
      [] -> "No templates available"
      _ ->
        random_template = Enum.random(templates)
        generate_sentence_from_template(random_template, user_id, is_admin)
    end
  end

  # Target specific template - use struct name to be more specific
  def random_sentence(user_id, is_admin, %Signcraft.Content.Template{} = target_template) do
    generate_sentence_from_template(target_template, user_id, is_admin)
  end

  # Target specific word - use struct name to be more specific
  def random_sentence(user_id, is_admin, %Signcraft.Content.Word{} = target_word) do
    templates = Content.list_templates_for_user(user_id, is_admin)
    target_type = target_word.word_type_id

    # Filter templates that include the target word type
    filtered_templates = Enum.filter(templates, fn template ->
      target_type in template.structure
    end)

    case filtered_templates do
      [] -> "No templates available using the target word"
      _ ->
        random_template = Enum.random(filtered_templates)
        generate_sentence_with_target_word(random_template, target_word, user_id, is_admin)
    end
  end

  # Helper function to generate sentence from template
  defp generate_sentence_from_template(template, user_id, is_admin) do
    sentence_words = Enum.map(template.structure, fn word_type_id ->
      generate_word_for_type_id(word_type_id, user_id, is_admin)
    end)

    Enum.join(sentence_words, " ")
  end

  # Helper function to generate sentence with target word
  defp generate_sentence_with_target_word(template, target_word, user_id, is_admin) do
    target_type = target_word.word_type_id

    # Use map_reduce to track if we've used the target word
    {sentence_words, _target_used} =
      Enum.map_reduce(template.structure, false, fn word_type_id, target_used ->
        if word_type_id == target_type and not target_used do
          # Use the target word for the first occurrence of this word type
          {target_word.text, true}
        else
          # Use generated word (number or regular word)
          word_text = generate_word_for_type_id(word_type_id, user_id, is_admin)
          {word_text, target_used}
        end
      end)

    Enum.join(sentence_words, " ")
  end

  # Core function to generate a word for a given word type ID
  defp generate_word_for_type_id(word_type_id, user_id, is_admin) do
    word_type = Content.get_word_type!(word_type_id)

    if word_type.is_number_type do
      # Generate random number in range
      Enum.random(word_type.number_min..word_type.number_max) |> to_string()
    else
      # Get regular words of this type
      words = Content.list_words_for_current_user(user_id, is_admin)
      |> Enum.filter(fn word -> word.word_type_id == word_type_id end)

      case words do
        [] -> "[missing]"
        available_words -> Enum.random(available_words).text
      end
    end
  end
end
