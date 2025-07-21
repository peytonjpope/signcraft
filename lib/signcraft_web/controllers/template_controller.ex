defmodule SigncraftWeb.TemplateController do
  use SigncraftWeb, :controller

  alias Signcraft.Content
  alias Signcraft.Content.Template

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    is_admin = conn.assigns.current_user.admin
    word_types = Content.list_word_types_for_user(conn.assigns.current_user.id, conn.assigns.current_user.admin)

    templates = Content.list_templates_for_user(user_id, is_admin)
    render(conn, :index, templates: templates, word_types: word_types)
  end

  def new(conn, _params) do
    changeset = Content.change_template(%Template{})
    word_types = Content.list_word_types_for_user(conn.assigns.current_user.id, conn.assigns.current_user.admin)
    render(conn, :new, changeset: changeset, word_types: word_types)
  end

  def create(conn, %{"template" => template_params}) do
    # Parse the JSON structure array
    template_params = case template_params["structure"] do
      structure when is_binary(structure) ->
        case Jason.decode(structure) do
          {:ok, parsed} -> Map.put(template_params, "structure", parsed)
          {:error, _} -> template_params
        end
      _ -> template_params
    end

    # Add user_id and admin status
    template_params = Map.put(template_params, "user_id", conn.assigns.current_user.id)
    is_admin = conn.assigns.current_user.admin

    case Content.create_template(template_params, is_admin) do
      {:ok, template} ->
        conn
        |> put_flash(:info, "Template created successfully.")
        |> redirect(to: ~p"/templates/#{template}")

      {:error, %Ecto.Changeset{} = changeset} ->
        word_types = Content.list_word_types_for_user(conn.assigns.current_user.id, conn.assigns.current_user.admin)
        render(conn, :new, changeset: changeset, word_types: word_types)
    end
  end

  def show(conn, %{"id" => id}) do
    template = Content.get_template!(id)
    word_types = Content.list_word_types_for_user(conn.assigns.current_user.id, conn.assigns.current_user.admin)
    render(conn, :show, template: template, word_types: word_types)
  end

  def edit(conn, %{"id" => id}) do
    template = Content.get_template!(id)
    changeset = Content.change_template(template)
    word_types = Content.list_word_types_for_user(conn.assigns.current_user.id, conn.assigns.current_user.admin)
    render(conn, :edit, template: template, changeset: changeset, word_types: word_types)
  end

  def update(conn, %{"id" => id, "template" => template_params}) do
    template = Content.get_template!(id)

    # Parse the JSON structure array (same as create)
    template_params = case template_params["structure"] do
      structure when is_binary(structure) ->
        case Jason.decode(structure) do
          {:ok, parsed} -> Map.put(template_params, "structure", parsed)
          {:error, _} -> template_params
        end
      _ -> template_params
    end

    is_admin = conn.assigns.current_user.admin

    case Content.update_template(template, template_params, is_admin) do
      {:ok, template} ->
        conn
        |> put_flash(:info, "Template updated successfully.")
        |> redirect(to: ~p"/templates/#{template}")

      {:error, %Ecto.Changeset{} = changeset} ->
        word_types = Content.list_word_types_for_user(conn.assigns.current_user.id, conn.assigns.current_user.admin)
        render(conn, :edit, template: template, changeset: changeset, word_types: word_types)
    end
  end

  def delete(conn, %{"id" => id}) do
    template = Content.get_template!(id)
    {:ok, _template} = Content.delete_template(template)

    conn
    |> put_flash(:info, "Template deleted successfully.")
    |> redirect(to: ~p"/templates")
  end
end
