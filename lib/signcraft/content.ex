defmodule Signcraft.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset, only: [change: 1, add_error: 3]
  alias Signcraft.Repo

  alias Signcraft.Content.Template
  alias Signcraft.Content.WordType
  alias Signcraft.Content.Word

  @doc """
  Returns the list of word_types.

  ## Examples

      iex> list_word_types()
      [%WordType{}, ...]

  """
  def list_word_types do
    Repo.all(WordType)
  end

  def list_word_types_for_user(user_id, is_admin) do
    query = if !is_admin do
      from(wt in WordType,
        where: wt.user_id == ^user_id,
        order_by: [asc: wt.name]
      )
    else
      from(wt in WordType,
        where: wt.is_system == true,
        order_by: [asc: wt.name]
      )
    end
    Repo.all(query)
  end

  @doc """
  Gets a single word_type.

  Raises `Ecto.NoResultsError` if the Word type does not exist.

  ## Examples

      iex> get_word_type!(123)
      %WordType{}

      iex> get_word_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_word_type!(id), do: Repo.get!(WordType, id)

  @doc """
  Creates a word_type.

  ## Examples

      iex> create_word_type(%{field: value})
      {:ok, %WordType{}}

      iex> create_word_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_word_type(attrs \\ %{}, is_admin \\ false) do
    %WordType{}
    |> WordType.changeset(attrs, is_admin)
    |> Repo.insert()
  end

  @doc """
  Updates a word_type.

  ## Examples

      iex> update_word_type(word_type, %{field: new_value})
      {:ok, %WordType{}}

      iex> update_word_type(word_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_word_type(%WordType{} = word_type, attrs, is_admin \\ false) do
    word_type
    |> WordType.changeset(attrs, is_admin)
    |> Repo.update()
  end

  @doc """
  Deletes a word_type.

  ## Examples

      iex> delete_word_type(word_type)
      {:ok, %WordType{}}

      iex> delete_word_type(word_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_word_type(%WordType{} = word_type) do
    # Check if any words use this word type
    word_count = from(w in Word, where: w.word_type_id == ^word_type.id)
                |> Repo.aggregate(:count, :id)

    # Check if any templates use this word type in their structure
    template_count = from(t in Template, where: ^word_type.id in t.structure)
                    |> Repo.aggregate(:count, :id)

    if word_count > 0 || template_count > 0 do
      changeset =
        word_type
        |> change()
        |> add_error(:base, "Cannot delete word type that is in use")

      {:error, changeset}
    else
      Repo.delete(word_type)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking word_type changes.

  ## Examples

      iex> change_word_type(word_type)
      %Ecto.Changeset{data: %WordType{}}

  """
  def change_word_type(%WordType{} = word_type, attrs \\ %{}) do
    WordType.changeset(word_type, attrs)
  end

  alias Signcraft.Content.Word

  @doc """
  Returns the list of words.

  ## Examples

      iex> list_words()
      [%Word{}, ...]

  """
  def list_words do
    Repo.all(Word) |> Repo.preload(:word_type)
  end

  def list_words_for_current_user(user_id, is_admin) do
    query = if !is_admin do
      from(w in Word,
        where: w.user_id == ^user_id,
        preload: :word_type,
        order_by: [asc: w.text]
      )
    else
      from(w in Word,
        where: w.is_system == true,
        preload: :word_type,
        order_by: [asc: w.text]
      )
    end
    Repo.all(query)
  end

  def list_words_for_user(user_id) do
    from(w in Word,
      where: w.user_id == ^user_id,
      preload: :word_type,
      order_by: [asc: w.text]
    )
    |> Repo.all()
  end


  @doc """
  Gets a single word.

  Raises `Ecto.NoResultsError` if the Word does not exist.

  ## Examples

      iex> get_word!(123)
      %Word{}

      iex> get_word!(456)
      ** (Ecto.NoResultsError)

  """
  def get_word!(id) do
    Repo.get!(Word, id) |> Repo.preload(:word_type)
  end

  @doc """
  Creates a word.

  ## Examples

      iex> create_word(%{field: value})
      {:ok, %Word{}}

      iex> create_word(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_word(attrs \\ %{}, is_admin \\ false) do
    %Word{}
    |> Word.changeset(attrs, is_admin)
    |> Repo.insert()
  end

  @doc """
  Updates a word.

  ## Examples

      iex> update_word(word, %{field: new_value})
      {:ok, %Word{}}

      iex> update_word(word, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_word(%Word{} = word, attrs, is_admin \\ false) do
    word
    |> Word.changeset(attrs, is_admin)
    |> Repo.update()
  end

  @doc """
  Deletes a word.

  ## Examples

      iex> delete_word(word)
      {:ok, %Word{}}

      iex> delete_word(word)
      {:error, %Ecto.Changeset{}}

  """
  def delete_word(%Word{} = word) do
    Repo.delete(word)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking word changes.

  ## Examples

      iex> change_word(word)
      %Ecto.Changeset{data: %Word{}}

  """
  def change_word(%Word{} = word, attrs \\ %{}) do
    Word.changeset(word, attrs)
  end

  alias Signcraft.Content.Template

  @doc """
  Returns the list of templates.

  ## Examples

      iex> list_templates()
      [%Template{}, ...]

  """
  def list_templates do
    Repo.all(Template)
  end

  def list_templates_for_user(user_id, is_admin) do
    query = if !is_admin do
      from(t in Template,
        where: t.user_id == ^user_id,
        order_by: [asc: t.name]
      )
    else
      from(t in Template,
        where: t.is_system == true,
        order_by: [asc: t.name]
      )
    end
    Repo.all(query)
  end

  @doc """
  Gets a single template.

  Raises `Ecto.NoResultsError` if the Template does not exist.

  ## Examples

      iex> get_template!(123)
      %Template{}

      iex> get_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_template!(id) do
    Repo.get!(Template, id)
  end

  @doc """
  Creates a template.

  ## Examples

      iex> create_template(%{field: value})
      {:ok, %Template{}}

      iex> create_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_template(attrs \\ %{}, is_admin \\ false) do
    %Template{}
    |> Template.changeset(attrs, is_admin)
    |> Repo.insert()
  end

  @doc """
  Updates a template.

  ## Examples

      iex> update_template(template, %{field: new_value})
      {:ok, %Template{}}

      iex> update_template(template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_template(%Template{} = template, attrs, is_admin \\ false) do
    template
    |> Template.changeset(attrs, is_admin)
    |> Repo.update()
  end

  @doc """
  Deletes a template.

  ## Examples

      iex> delete_template(template)
      {:ok, %Template{}}

      iex> delete_template(template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_template(%Template{} = template) do
    Repo.delete(template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking template changes.

  ## Examples

      iex> change_template(template)
      %Ecto.Changeset{data: %Template{}}

  """
  def change_template(%Template{} = template, attrs \\ %{}) do
    Template.changeset(template, attrs)
  end

  @doc """
Copies all system content (word types, words, templates) to a new user.
Called when a user registers.
"""
def setup_user_content(user_id) do
  Repo.transaction(fn ->
    # Copy system word types
    system_word_types = from(wt in WordType, where: wt.is_system == true) |> Repo.all()

    word_type_mapping = Enum.reduce(system_word_types, %{}, fn system_wt, acc ->
      {:ok, new_wt} = create_word_type(%{
        name: system_wt.name,
        user_id: user_id
      }, false) # is_admin = false for user copies

      Map.put(acc, system_wt.id, new_wt.id)
    end)

    # Copy system words
    system_words = from(w in Word, where: w.is_system == true, preload: :word_type) |> Repo.all()

    Enum.each(system_words, fn system_word ->
      new_word_type_id = Map.get(word_type_mapping, system_word.word_type_id)

      if new_word_type_id do
        create_word(%{
          text: system_word.text,
          word_type_id: new_word_type_id,
          user_id: user_id
        }, false) # is_admin = false for user copies
      end
    end)

    # Copy system templates
    system_templates = from(t in Template, where: t.is_system == true) |> Repo.all()

    Enum.each(system_templates, fn system_template ->
      # Map old word type IDs to new user's word type IDs
      new_structure = Enum.map(system_template.structure, fn old_word_type_id ->
        Map.get(word_type_mapping, old_word_type_id, old_word_type_id)
      end)

      create_template(%{
        name: system_template.name,
        structure: new_structure,
        user_id: user_id
      }, false) # is_admin = false for user copies
    end)

    :ok
  end)
end



end
