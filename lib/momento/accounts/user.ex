defmodule Momento.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:password_hash, :string)
    field(:username, :string)
    field(:password, :string, virtual: true)

    has_many(:slices, Momento.Media.Slice)
    has_many(:comments, Momento.Media.Comment)
    has_many(:likes, Momento.Media.Like)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
    |> unique_constraint(:email, downcase: true)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
