defmodule SigncraftWeb.HomeController do
  use SigncraftWeb, :controller

  def redirect_to_home(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: ~p"/home")
    else
      redirect(conn, to: ~p"/users/log_in")
    end
  end

  def show(conn, _params) do
    user_id = conn.assigns.current_user.id
    is_admin = conn.assigns.current_user.admin
    sentence = Signcraft.SentenceGenerator.random_sentence(user_id, is_admin)
    render(conn, :show, sentence: sentence)
  end

end
