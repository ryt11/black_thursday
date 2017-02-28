require_relative 'test_helper'
require './lib/sales_engine'
require './lib/transaction'

class TransactionTest < Minitest::Test
	attr_reader :transaction
	def setup
		@transaction = Transaction.new({:id => "7".to_i, :credit_card_number => "4613250127567219".to_i, :invoice_id => "1298".to_i, 
			:credit_card_expiration_date => "2012-02-26 20:56:57 UTC", :result => "success", 
			:created_at => Time.parse('2012-02-26 20:56:57 UTC'), 
			:updated_at => Time.parse('2012-02-26 20:56:57 UTC')}, nil)
	end

	def test_transaction_info_exists
		expected = {:id => "7".to_i, :credit_card_number => "4613250127567219".to_i, :invoice_id => "1298".to_i, 
			:credit_card_expiration_date => Time.parse("2012-02-26 20:56:57 UTC"), :result => "success", 
			:created_at => Time.parse('2012-02-26 20:56:57 UTC'), 
			:updated_at => Time.parse('2012-02-26 20:56:57 UTC')}
		assert_equal expected, transaction.transaction_info
	end

	def test_transaction_instance_exists
		assert_nil transaction.trans_inv_instance
	end

	def test_instance_of_transaction
		assert_equal Transaction, transaction.class
	end

	def test_transaction_has_an_id
		assert_equal 7, transaction.id
	end

	def test_transaction_has_a_credit_card_number
		assert_equal 4613250127567219, transaction.credit_card_number
	end

	def test_transaction_has_a_credit_card_expiration_date
		expected = "2012-02-26 20:56:57 UTC"
		assert_equal expected, transaction.credit_card_expiration_date
	end

	def test_transaction_has_an_invoice_id
		assert_equal 1298, transaction.invoice_id
	end

	def test_transaction_has_a_created_at
		expected = Time.parse("2012-02-26 20:56:57 UTC")
		assert_equal expected, transaction.created_at
	end

	def test_transaction_has_a_updated_at
		expected = Time.parse("2012-02-26 20:56:57 UTC")
		assert_equal expected, transaction.updated_at
	end
end
