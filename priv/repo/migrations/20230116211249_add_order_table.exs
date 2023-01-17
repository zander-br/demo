defmodule Demo.Repo.Migrations.AddOrderTable do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :customer, :string
      add :paid, :boolean

      timestamps()
    end
  end
end
