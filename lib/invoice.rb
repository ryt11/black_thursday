require 'bigdecimal'
require 'pry'
require 'time'

class Invoice
attr_reader :invoice_info, :inv_parent
  def initialize(invoice_info, inv_parent)
    @invoice_info = invoice_info
    @inv_parent = inv_parent
  end

  def id
    invoice_info[:id]
  end

  def customer_id
    invoice_info[:customer_id]
  end

  def status
    invoice_info[:status]
  end

  def created_at
    invoice_info[:created_at]
  end

  def updated_at
    invoice_info[:updated_at]
  end

  def merchant_id
    invoice_info[:merchant_id]
  end

  def items
    invoice_items_found = inv_parent.sales_engine_instance.invoice_items.find_all_by_invoice_id(id)
    item_ids = invoice_items_found.map { |invoice_item| invoice_item.item_id }
    item_ids.map {|item_id| inv_parent.sales_engine_instance.items.find_by_id(item_id)}
  end

  def transactions
    inv_parent.sales_engine_instance.transactions.find_all_by_invoice_id(id)
  end

  def customer
    inv_parent.sales_engine_instance.customers.find_by_id(customer_id)
  end

  def is_paid_in_full?
    found = inv_parent.sales_engine_instance.transactions.find_all_by_invoice_id(id)
    found.any? { |transaction| transaction.result == "success" }
  end

  def total
    return 0.0 unless is_paid_in_full?
    # items.map{|item| item.total}.reduce(:+)
    invoice_items_found = inv_parent.sales_engine_instance.invoice_items.find_all_by_invoice_id(id)
    invoice_items_found.map  { |invoice_item| invoice_item.quantity * invoice_item.unit_price }.reduce(:+)
  end

end
