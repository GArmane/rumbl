defmodule Rumbl.TestHelpers do
  alias Rumbl.Repo
  alias Rumbl.Users.User

  def insert_user(attr \\ %{}) do
    changes = Map.merge(%{
      name: "Some user",
      username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
      username: "supersecret",
    }, attr)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_video(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos, attrs)
    |> Repo.insert!()
  end
end
