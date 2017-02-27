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

	def find_items_by_invoice_id(invoice_id)
	invoice_items = find_invoice_items_by_invoice_id(invoice_id)
	item_ids = invoice_items.map {|invoice_item| invoice_item.item_id}
	item_ids.map {|item_id| items.find_by_id(item_id)}
end



  def items
		invoice_items_found = inv_parent.sales_engine_instance.invoice_items.find_all_by_invoice_id(id)
		item_ids = invoice_items_found.map { |invoice_item| invoice_item.item_id }
		item_ids.map {|item_id| inv_parent.sales_engine_instance.items.find_by_id(item_id)}
  end
end
