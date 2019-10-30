defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  alias RumblWeb.UserView

  alias Rumbl.Repo
  alias Rumbl.Annotations
  alias Rumbl.Videos

  alias Rumbl.Users.User


  def join("videos:" <> video_id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Videos.get_video!(video_id)

    annotations = Annotations.list_by_video(video, last_seen_id)
    {:ok, annotations, assign(socket, :video_id, video_id)}
  end

  def handle_in(event, params, socket) do
    user = Repo.get(User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    video_id = socket.assigns.video_id

    case Annotations.create(user, video_id, params) do
      {:ok, annotation} ->
        broadcast! socket, "new_annotation", %{
          id: annotation.id,
          user: UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at,
        }
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
