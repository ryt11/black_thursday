require_relative 'test_helper'
require './lib/sales_engine'
require './lib/invoice_item'

class InvoiceItemTest < Minitest::Test
	attr_reader :invoice_item
	def setup
		@invoice_item = InvoiceItem.new({:id => "13".to_i, :item_id => "263553176".to_i, :invoice_id => "3".to_i, 
			:quantity => "4".to_i, :unit_price => BigDecimal.new("78660".to_i)/100, :created_at => Time.parse('2012-03-27 14:54:09 UTC'), 
			:updated_at => Time.parse('2012-03-27 14:54:09 UTC')}, nil)
	end

	def test_invoice_item_info_exists
		expected = {:id => "13".to_i, :item_id => "263553176".to_i, :invoice_id => "3".to_i, 
			:quantity => "4".to_i, :unit_price => BigDecimal.new("78660".to_i)/100, :created_at => Time.parse('2012-03-27 14:54:09 UTC'), 
			:updated_at => Time.parse('2012-03-27 14:54:09 UTC')}
		assert_equal expected, invoice_item.invoice_item_info
	end

	def test_invoice_item_instance_exists
		assert_nil invoice_item.inv_repo_instance
	end

	def test_instance_of_invoice_item
		assert_equal InvoiceItem, invoice_item.class
	end

	def test_invoice_item_has_an_id
		assert_equal 13, invoice_item.id
	end

	def test_invoice_item_has_an_item_id
		assert_equal 263553176, invoice_item.item_id
	end

	def test_invoice_item_has_a_quantity
		assert_equal 4, invoice_item.quantity
	end

	def test_invoice_item_has_a_unit_price
		big_inst = BigDecimal.new("78660".to_i)/100
		assert_equal big_inst, invoice_item.unit_price
	end

	def test_item_has_a_created_at
		expected = Time.parse('2012-03-27 14:54:09 UTC')
		assert_equal expected, invoice_item.created_at
	end

	def test_item_has_a_updated_at
		expected = Time.parse('2012-03-27 14:54:09 UTC')
		assert_equal expected, invoice_item.updated_at
	end
end
