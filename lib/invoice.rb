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
    inv_item = inv_parent.se_inst.invoice_items.find_all_by_invoice_id(id)
    item_ids = inv_item.map { |invoice_item| invoice_item.item_id }
    item_ids.map {|item_id| inv_parent.se_inst.items.find_by_id(item_id)}
  end

  def transactions
    inv_parent.se_inst.transactions.find_all_by_invoice_id(id)
  end

  def customer
    inv_parent.se_inst.customers.find_by_id(customer_id)
  end

  def merchant
    inv_parent.se_inst.merchants.find_by_id(merchant_id)
  end

  def is_paid_in_full?
    found = inv_parent.se_inst.transactions.find_all_by_invoice_id(id)
    found.any? { |transaction| transaction.result == "success" }
  end

  def total
    return 0.0 unless is_paid_in_full?
    inv_item = inv_parent.se_inst.invoice_items.find_all_by_invoice_id(id)
    inv_item.map do |invoice_item|
      invoice_item.quantity * invoice_item.unit_price
    end.reduce(:+)
  end
end