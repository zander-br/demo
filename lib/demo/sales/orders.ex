defmodule Demo.Sales.Orders do
  alias Demo.Sales.Order
  alias Demo.Repo

  def get_by_id(id) do
    Order
    |> Repo.get(id)
    |> Repo.preload(:items)
    |> handle_get()
  end

  def get_by_customer(customer) do
    Order
    |> Repo.get_by(customer: customer)
    |> handle_get()
  end

  def insert(order), do: Repo.insert(order)

  def update(order), do: Repo.update(order)

  defp handle_get(%Order{} = order), do: {:ok, order}
  defp handle_get(nil), do: {:error, :order_not_found}
end
