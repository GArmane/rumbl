defmodule Rumbl.Annotations.Annotation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rumbl.Users.User
  alias Rumbl.Videos.Video

  schema "annotations" do
    field :at, :integer
    field :body, :string
    # field :user_id, :id
    # field :video_id, :id
    belongs_to :user, User
    belongs_to :video, Video

    timestamps()
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at])
    |> validate_required([:body, :at])
  end
end
