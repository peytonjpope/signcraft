defmodule SigncraftWeb.WordTypeHTML do
  use SigncraftWeb, :html

  embed_templates "word_type_html/*"

  @doc """
  Renders a word_type form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def word_type_form(assigns)
end
