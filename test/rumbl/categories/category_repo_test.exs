defmodule Rumbl.CategoryRepoTest do
  use Rumbl.DataCase

  alias Rumbl.Categories
  alias Rumbl.Categories.Category

  test "list_categories/0 orders by name" do
    Repo.insert!(%Category{name: "c"})
    Repo.insert!(%Category{name: "a"})
    Repo.insert!(%Category{name: "b"})

    categories =
      Categories.list_categories()
      |> Enum.map(fn {name, _} -> name end)

    assert categories == ~w(a b c)
  end
end
