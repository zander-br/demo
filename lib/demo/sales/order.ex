defmodule Demo.Sales.Order do
  use Ecto.Schema

  import Ecto.Changeset

  alias Demo.Sales.Item
  alias Ecto.Changeset

  @maximum_items_per_order 3

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "orders" do
    field :customer, :string
    field :paid, :boolean, default: false

    has_many :items, Item

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:customer])
    |> validate_required([:customer])
    |> cast_assoc(:items)
  end

  def order_total(%__MODULE__{items: items}), do: Enum.reduce(items, 0, &total/2)

  def add_item(%__MODULE__{paid: false, items: items} = order, item)
      when length(items) < @maximum_items_per_order do
    item
    |> create_item()
    |> check_if_item_already_exists(items)
    |> add_item_to_order(order)
  end

  def add_item(%__MODULE__{paid: false}, _item), do: {:error, :order_with_maximum_number_of_items}
  def add_item(_order, _item), do: {:error, :order_already_paid}

  def pay_order(%__MODULE__{paid: false} = order) do
    changeset = order |> change() |> put_change(:paid, true)
    {:ok, changeset}
  end

  def pay_order(_order), do: {:error, :order_already_paid}

  defp create_item(params) do
    case Item.changeset(%Item{}, params) do
      %Changeset{valid?: true} = changeset -> {:ok, changeset}
      changeset -> {:error, changeset}
    end
  end

  defp check_if_item_already_exists({:ok, changeset}, items) do
    %Changeset{changes: %{product_name: product_name}} = changeset

    case Enum.find(items, fn item -> item.product_name == product_name end) do
      nil -> {:ok, changeset}
      _item -> {:error, :item_already_exists}
    end
  end

  defp check_if_item_already_exists({:error, %Changeset{errors: errors}}, _items),
    do: {:error, errors}

  defp add_item_to_order({:ok, item}, %__MODULE__{items: items} = order) do
    changeset =
      order
      |> change()
      |> put_assoc(:items, [item | items])

    {:ok, changeset}
  end

  defp add_item_to_order({:error, reason}, _order), do: {:error, reason}

  defp total(%Item{} = item, acc), do: subtotal(item) + acc
  defp subtotal(%Item{quantity: quantity, price: price}), do: quantity * price
end
