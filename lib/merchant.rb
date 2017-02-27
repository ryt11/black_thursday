class Merchant
	attr_reader :merchant_info, :mr_instance
	def initialize(merchant_info, mr_instance)
		@merchant_info = merchant_info
		@mr_instance = mr_instance
	end

	def name
		merchant_info[:name]
	end

	def id
		merchant_info[:id]
	end

	def items
		mr_instance.sales_engine_instance.items.find_all_by_merchant_id(id)
	end

	def invoices
		mr_instance.sales_engine_instance.invoices.find_all_by_merchant_id(id)
	end

	def customers
		invoices = mr_instance.sales_engine_instance.invoices.find_all_by_merchant_id(id)
		customer_ids = invoices.map { |invoice| invoice.customer_id }
		customer_ids.map { |customer_id| mr_instance.sales_engine_instance.customers.find_by_id(customer_id) }
	end
end
