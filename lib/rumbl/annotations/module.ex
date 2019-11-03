defmodule Rumbl.Annotations do
  import Ecto.Query, warn: false

  alias Phoenix.View

  alias RumblWeb.AnnotationView

  alias Rumbl.Repo
  alias Rumbl.Annotations.Annotation
  alias Rumbl.Users.User

  def list do
    Repo.all(Annotation)
  end

  def list_by_video(video, last_seen_id \\ 0) do
    annotations = Repo.all(
      from a in Ecto.assoc(video, :annotation),
      where: a.id > ^last_seen_id,
      order_by: [asc: a.at, asc: a.id],
      limit: 200,
      preload: [:user]
    )

    %{annotations: View.render_many(
      annotations, AnnotationView, "annotation.json"
    )}
  end

  def create(user, video_id, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:annotation, video_id: video_id)
    |> Annotation.changeset(attrs)
    |> Repo.insert()
  end

  def fetch_user(annotation) do
    annotation
    |> Repo.preload(:user)
  end
end
