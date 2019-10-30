defmodule Rumbl.Annotations do
  import Ecto.Query, warn: false

  alias Phoenix.View

  alias RumblWeb.AnnotationView

  alias Rumbl.Repo
  alias Rumbl.Annotations.Annotation

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

    %{annotations: Phoenix.View.render_many(
      annotations, AnnotationView, "annotation.json"
    )}
  end

  def create(user, video_id, attrs \\ %{}) do
    changeset =
      user
      |> Ecto.build_assoc(:annotation, video_id: video_id)
      |> Annotation.changeset(attrs)
      |> Repo.insert()
  end

  # def get_annotation!(id), do: Repo.get!(Annotation, id)

  # def create_annotation(attrs \\ %{}) do
  #   %Annotation{}
  #   |> Annotation.changeset(attrs)
  #   |> Repo.insert()
  # end

  # def update_annotation(%Annotation{} = annotation, attrs) do
  #   annotation
  #   |> Annotation.changeset(attrs)
  #   |> Repo.update()
  # end

  # def delete_annotation(%Annotation{} = annotation) do
  #   Repo.delete(annotation)
  # end

  # def change_annotation(%Annotation{} = annotation) do
  #   Annotation.changeset(annotation, %{})
  # end
end
