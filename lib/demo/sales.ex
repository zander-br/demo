defmodule Demo.Sales do
  alias Demo.Sales.{Order, Orders}

  def create_new_order(%{customer: customer} = order_params) do
    with {:error, :order_not_found} <- Orders.get_by_customer(customer) do
      order_params
      |> Order.changeset()
      |> Orders.insert()
    else
      _ -> {:error, :customer_already_has_open_order}
    end
  end

  def add_item_to_order(order_id, new_item) do
    with {:ok, order} <- Orders.get_by_id(order_id),
         {:ok, updated_order} <- Order.add_item(order, new_item) do
      Orders.update(updated_order)
    else
      error -> error
    end
  end

  def pay_order(order_id) do
    with {:ok, order} <- Orders.get_by_id(order_id),
         {:ok, updated_order} <- Order.pay_order(order) do
      Orders.update(updated_order)
    else
      error -> error
    end
  end
end
