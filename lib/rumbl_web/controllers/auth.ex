defmodule RumblWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias Rumbl.Users.User
  alias RumblWeb.Router.Helpers, as: Routes

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    cond do
      _user = conn.assigns[:current_user] ->
        conn
      user = user_id && repo.get(User, user_id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def login_by_username_and_pass(conn, username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, username: username)

    cond do
      user ->
        case Argon2.check_pass(user, given_pass) do
          {:ok, _} ->
            {:ok, login(conn, user)}
          _ ->
            {:error, :unauthorized, conn}
        end
      true ->
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
