defmodule Rumbl.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rumbl.Videos.Video

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: :true
    field :password_hash, :string
    has_many :videos, Video

    timestamps()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(pass))
      _ ->
        changeset
    end
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :username], [])
    |> validate_length(:username, min: 1, max: 20)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, [:password], [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end
end
