require_relative 'test_helper'
require './lib/sales_engine'
require './lib/customer'

class CustomerTest < Minitest::Test
	attr_reader :customer
	def setup
		@customer = Customer.new({:id => "8".to_i, :first_name => "Loyal", :last_name => "Considine",
    :created_at => Time.parse('2012-03-27 14:54:11 UTC'), :updated_at => Time.parse('2012-03-27 14:54:11 UTC')}, nil)
	end

	def test_customer_info_exists
		expected = {:id => "8".to_i, :first_name => "Loyal", :last_name => "Considine",
    :created_at => Time.parse('2012-03-27 14:54:11 UTC'), :updated_at => Time.parse('2012-03-27 14:54:11 UTC')}
		assert_equal expected, customer.customer_info
	end

	def test_customer_instance_exists
		assert_nil customer.cust_repo_instance
	end

	def test_instance_of_customer
		assert_equal Customer, customer.class
	end

	def test_customer_has_a_first_name
		assert_equal 'Loyal', customer.first_name
	end

	def test_customer_has_a_last_name
		assert_equal 'Considine', customer.last_name
	end

	def test_customer_has_an_id
		assert_equal 8, customer.id
	end

	def test_customer_has_a_created_at
		expected = Time.parse('2012-03-27 14:54:11 UTC')
		assert_equal expected, customer.created_at
	end

	def test_customer_has_a_updated_at
		expected = Time.parse('2012-03-27 14:54:11 UTC')
		assert_equal expected, customer.updated_at
	end
end
