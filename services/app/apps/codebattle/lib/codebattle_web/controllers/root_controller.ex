defmodule CodebattleWeb.RootController do
  use CodebattleWeb, :controller

  import PhoenixGon.Controller

  alias Codebattle.Repo
  alias Codebattle.User
  alias CodebattleWeb.Api.LobbyView
  alias CodebattleWeb.Api.UserView
  alias CodebattleWeb.LayoutView

  def index(conn, params) do
    current_user = conn.assigns.current_user

    if current_user.is_guest do
      render(conn, "landing.html", layout: {LayoutView, "landing.html"})
    else
      conn
      |> maybe_put_opponent(params)
      |> put_gon(
        task_tags: ["strings", "math", "hash-maps", "collections", "rest"],
        active_games: LobbyView.render_active_games(current_user),
        tournaments: [],
        completed_games: [],
        leaderboard_users: []
      )
      |> render("index.html", current_user: current_user)
    end
  end

  def feedback(conn, _) do
    render(conn, "feedback.xml")
  end

  def robots(conn, _) do
    render(conn, "robots.txt")
  end

  def sitemap(conn, _) do
    render(conn, "sitemap.xml")
  end

  defp maybe_put_opponent(conn, %{"opponent_id" => id}) do
    case User.get(id) do
      nil -> conn
      user -> put_gon(conn, opponent: Map.take(user, [:id, :name, :rating, :rank]))
    end
  end

  defp maybe_put_opponent(conn, _params), do: conn
end
