defmodule Pento.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :stars, :integer
      add :user_id, references(:users, on_delete: :delete_all)
      add :product_id, references(:products, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:ratings, [:user_id, :product_id])
  end
end
