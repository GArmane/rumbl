defmodule Rumbl.VideoViewTest do
  use RumblWeb.ConnCase, async: true

  import Phoenix.View

  alias Rumbl.Videos.Video
  alias Rumbl.Categories.Category
  alias RumblWeb.VideoView

  test "renders index.html", %{conn: conn} do
    videos = [
      %Video{id: "1", title: "dogs", category: %Category{name: "test"}},
      %Video{id: "2", title: "cats", category: %Category{name: "test"}}
    ]

    content = render_to_string(VideoView, "index.html", conn: conn, videos: videos)
    assert String.contains?(content, "Listing Videos")

    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Video.changeset(%Video{id: "1", title: "dogs"}, %{})
    categories = [{"cats", 123}]

    content = render_to_string(
      VideoView, "new.html", conn: conn,
      changeset: changeset, categories: categories
    )

    assert String.contains?(content, "New Video")
  end
end
