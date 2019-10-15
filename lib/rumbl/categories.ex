defmodule Rumbl.Categories do
  @moduledoc """
  The Categories context.
  """

  import Ecto.Query, warn: false

  alias Rumbl.Repo
  alias Rumbl.Categories.Category

  defp alphabetical(query) do
    from c in query, order_by: c.name
  end

  defp names_and_ids(query) do
    from c in query, select: { c.name, c.id }
  end

  def list_categories do
    Category
    |> alphabetical
    |> names_and_ids
    |> Repo.all
  end
end
