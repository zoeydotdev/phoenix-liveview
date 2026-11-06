defmodule Pento.Survey.Demographic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Accounts.User

  @genders ["male", "female", "other", "prefer not to say"]
  @years_of_birth 1900..2010

  schema "demographics" do
    field :gender, :string
    field :year_of_birth, :integer
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(demographic, attrs, user_scope) do
    demographic
    |> cast(attrs, [:gender, :year_of_birth])
    |> validate_required([:gender, :year_of_birth])
    |> validate_inclusion(:gender, genders())
    |> validate_inclusion(:year_of_birth, years_of_birth())
    |> put_change(:user_id, user_scope.user.id)
    |> unique_constraint(:user_id)
  end

  def genders, do: @genders
  def years_of_birth, do: @years_of_birth
end
