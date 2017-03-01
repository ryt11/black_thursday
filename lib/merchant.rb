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

  def created_at
    merchant_info[:created_at]
  end

  def items
    mr_instance.se_inst.items.find_all_by_merchant_id(id)
  end


  def invoices
    mr_instance.se_inst.invoices.find_all_by_merchant_id(id)
  end

  def customers
    invoices = mr_instance.se_inst.invoices.find_all_by_merchant_id(id)
    customer_ids = invoices.map { |invoice| invoice.customer_id }
    final = customer_ids.uniq.map do |customer_id|
      mr_instance.se_inst.customers.find_by_id(customer_id)
    end
  end
end
