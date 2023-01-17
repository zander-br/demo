defmodule Demo.Repo.Migrations.AddItemTable do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :product_name, :string
      add :quantity, :integer
      add :price, :float
      add :order_id, references(:orders, type: :binary_id)

      timestamps()
    end
  end
end
