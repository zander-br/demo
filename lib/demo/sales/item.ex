defmodule Demo.Sales.Item do
  use Ecto.Schema

  import Ecto.Changeset

  alias Demo.Sales.Order

  @fields ~w(product_name quantity price)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :product_name, :string
    field :quantity, :integer
    field :price, :float

    belongs_to :order, Order

    timestamps()
  end

  def changeset(item, params) do
    item
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:quantity, greater_than: 0)
    |> validate_number(:price, greater_than: 0)
  end
end
