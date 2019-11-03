defmodule Rumbl.Users do
  import Ecto.Query, warn: false

  alias Rumbl.Repo
  alias Rumbl.Users.User

  def get_by_id(id) do
    Repo.get!(User, id)
  end

  def get_by_username(username) do
    Repo.get_by!(User, username: username)
  end
end
