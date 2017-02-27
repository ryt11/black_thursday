require 'bigdecimal'
require 'pry'


class Customer
    attr_reader :customer_info, :cust_repo_instance
  def initialize(customer_info, cust_repo_instance)
    @customer_info = customer_info
    @cust_repo_instance = cust_repo_instance
  end

  def first_name
    @customer_info[:first_name]
  end

  def id
    @customer_info[:id]
  end

  def last_name
    @customer_info[:last_name]
  end


  def created_at
    @customer_info[:created_at]
  end

  def updated_at
    @customer_info[:updated_at]
  end

  def merchants
    invoices = cust_repo_instance.sales_engine_instance.invoices.find_all_by_customer_id(id)
    merchant_ids = invoices.map { |invoice| invoice.merchant_id }
    merchant_ids.map { |merchant_id| cust_repo_instance.sales_engine_instance.merchants.find_by_id(merchant_id) }
  end
end
