defmodule Rumbl.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rumbl.Users.User
  alias Rumbl.Categories.Category

  @primary_key {:id, Rumbl.Videos.Permalink, autogenerate: true}

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :slug, :string
    belongs_to :user, User
    belongs_to :category, Category

    timestamps()
  end

  # Implementations

  defimpl Phoenix.Param, for: Rumbl.Videos.Video  do
    def to_param(%{slug: slug, id: id}) do
      "#{id}-#{slug}"
    end
  end

  # Private API

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, slugify(title))
    else
      changeset
    end
  end

  # Public APi

  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description, :category_id])
    |> validate_required([:url, :title, :description])
    |> slugify_title()
    |> assoc_constraint(:category)
  end
end
