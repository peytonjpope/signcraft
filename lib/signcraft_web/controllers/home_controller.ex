defmodule SigncraftWeb.HomeController do
  use SigncraftWeb, :controller
  alias Signcraft.Content

  def redirect_to_home(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: ~p"/home")
    else
      redirect(conn, to: ~p"/users/log_in")
    end
  end

  def show(conn, params) do
    if !conn.assigns[:current_user] do
      redirect(conn, to: ~p"/users/log_in")
      |> halt()
    end

    user_id = conn.assigns.current_user.id
    is_admin = conn.assigns.current_user.admin

    # Get current targeting from session
    current_word_id = get_session(conn, :target_word_id)
    current_template_id = get_session(conn, :target_template_id)

    # Determine new targeting based on params or maintain current
    {new_word_id, new_template_id, conn} = case params do
      # User clicked "None" - clear all targeting
      %{"clear_targeting" => "true"} ->
        conn = conn
        |> put_session(:target_word_id, nil)
        |> put_session(:target_template_id, nil)
        {nil, nil, conn}

      # User selected a specific word
      %{"target_word_id" => word_id} when word_id != "" and word_id != nil ->
        conn = conn
        |> put_session(:target_word_id, word_id)
        |> put_session(:target_template_id, nil)
        {word_id, nil, conn}

      # User selected a specific template
      %{"target_template_id" => template_id} when template_id != "" and template_id != nil ->
        conn = conn
        |> put_session(:target_word_id, nil)
        |> put_session(:target_template_id, template_id)
        {nil, template_id, conn}

      # User clicked "Generate Sentence" or navigated to /home without params - maintain current targeting
      _ ->
        {current_word_id, current_template_id, conn}
    end

    # Generate sentence based on current targeting
    sentence = cond do
      new_word_id != nil ->
        target_word = Content.get_word!(new_word_id)
        Signcraft.SentenceGenerator.random_sentence(user_id, is_admin, target_word)

      new_template_id != nil ->
        target_template = Content.get_template!(new_template_id)
        Signcraft.SentenceGenerator.random_sentence(user_id, is_admin, target_template)

      true ->
        Signcraft.SentenceGenerator.random_sentence(user_id, is_admin)
    end

    # Get data for the forms
    words = Content.list_words_for_current_user(user_id, is_admin)
    templates = Content.list_templates_for_user(user_id, is_admin)

    word_options = [{"Target a word...", ""}] ++ Enum.map(words, &{"#{&1.text} (#{&1.word_type.name})", &1.id})
    template_options = [{"Target a template...", ""}] ++ Enum.map(templates, &{&1.name, &1.id})

    new_word = if new_word_id do
      Content.get_word!(new_word_id).text
    else
      nil
    end
    new_template = if new_template_id do
      Content.get_template!(new_template_id).name
    else
      nil
    end

    render(conn, :show,
      sentence: sentence,
      word_options: word_options,
      template_options: template_options,
      selected_word_id: new_word_id || "",
      selected_template_id: new_template_id || "",
      new_word: new_word || "",
      new_template: new_template || ""
    )
  end

  def about(conn, _params) do
    render(conn, :about)
  end
end
