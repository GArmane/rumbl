defmodule Rumbl.Videos do
  import Ecto.Query, warn: false

  alias Rumbl.Repo
  alias Rumbl.Videos.Video

  defp user_videos(user), do: Ecto.assoc(user, :videos)

  def list_videos do
    Repo.all(Video)
    |> Repo.preload(:category)
  end

  def list_videos(user) do
    user
    |> user_videos
    |> Repo.all
    |> Repo.preload(:category)
  end

  def get_video!(id),
  do: Repo.get!(Video, id)

  def get_video!(user, id),
  do: user |> user_videos |> Repo.get!(id) |> Repo.preload(:category)

  def create_video(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos)
    |> Video.changeset(attrs)
    |> Repo.insert
  end

  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end

  def change_video(%Video{} = video, params) do
    Video.changeset(video, params)
  end

  def new_video(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos)
    |> change_video(attrs)
  end
end
