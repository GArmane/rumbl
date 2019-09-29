defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  alias Rumbl.Repo
  alias RumblWeb.User

  def index(conn, _params) do
    users = Repo.all User
    render conn, "index.html", users: users
  end
end
