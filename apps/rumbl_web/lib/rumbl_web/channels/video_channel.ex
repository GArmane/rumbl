defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  alias Phoenix.View

  alias RumblWeb.AnnotationView

  alias Rumbl.Annotations
  alias Rumbl.Videos
  alias Rumbl.Users

  def join("videos:" <> video_id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Videos.get_video!(video_id)

    annotations = Annotations.list_by_video(video, last_seen_id)
    {:ok, annotations, assign(socket, :video_id, video_id)}
  end

  def handle_in(event, params, socket) do
    user = Users.get_by_id(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    video_id = socket.assigns.video_id

    case Annotations.create(user, video_id, params) do
      {:ok, annotation} ->
        broadcast_annotation(socket, annotation)
        Task.start_link(fn ->
          compute_additional_info(annotation, socket)
        end)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  defp broadcast_annotation(socket, annotation) do
    annotation = Annotations.fetch_user(annotation)
    rendered_ann = View.render(AnnotationView, "annotation.json", %{
      annotation: annotation
    })
    broadcast! socket, "new_annotation", rendered_ann
  end

  defp compute_additional_info(ann, socket) do
    for result <- InfoSys.compute(ann.body, limit: 1, timeout: 10_000) do
      user = Users.get_by_username(result.backend)
      video_id = ann.video_id
      attrs = %{url: result.url, body: result.text, at: ann.at}

      case Annotations.create(user, video_id, attrs) do
        {:ok, info_ann} -> broadcast_annotation(socket, info_ann)
        {:error, _changeset} -> :ignore
      end
    end
  end
end
