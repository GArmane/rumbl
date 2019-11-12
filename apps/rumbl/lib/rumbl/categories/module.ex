defmodule Rumbl.Categories do
  import Ecto.Query, warn: false

  alias Rumbl.Repo
  alias Rumbl.Categories.Category

  # Private API

  defp alphabetical(query) do
    from c in query, order_by: c.name
  end

  defp names_and_ids(query) do
    from c in query, select: { c.name, c.id }
  end

  # Public API

  def list_categories do
    Category
    |> alphabetical
    |> names_and_ids
    |> Repo.all
  end
end
