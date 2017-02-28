require_relative 'test_helper'
require './lib/sales_engine'
require './lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test 
	attr_reader :se, :trans_repo
	def setup
		@se = SalesEngine.from_csv({
  	:transactions => "./test/fixtures/transaction_fixture.csv",
		})
		@trans_repo = se.transactions
	end

	def test_it_exists
		assert_equal TransactionRepository, trans_repo.class
	end

	def test_invoices_hash_populates
		refute trans_repo.transactions.empty?
	end

	def test_all_method_returns_array_of_all_invoices
		assert_equal 524, trans_repo.all.count
		assert_equal Array, trans_repo.all.class
	end

	def test_find_by_id	
		assert_equal Transaction, trans_repo.find_by_id(12).class
		assert_nil trans_repo.find_by_id('horse')
	end

	def test_find_all_by_invoice_id
		assert_equal Array, trans_repo.find_all_by_invoice_id(2179).class
		assert_equal Array, trans_repo.find_all_by_invoice_id(4126).class
		assert_equal Transaction, trans_repo.find_all_by_invoice_id(4126).first.class
		assert_equal [], trans_repo.find_all_by_invoice_id(333333333333)
		assert_equal 1, trans_repo.find_all_by_invoice_id(2179).first.id
	end

	def test_find_all_by_credit_card_number
		assert_equal Array, trans_repo.find_all_by_credit_card_number(4068631943231473).class
		assert_equal Array, trans_repo.find_all_by_credit_card_number(4297222478855497).class
		assert_equal Transaction, trans_repo.find_all_by_credit_card_number(4068631943231473).first.class
		assert_equal Array.new, trans_repo.find_all_by_credit_card_number(111111111111)
		assert_equal 1, trans_repo.find_all_by_credit_card_number(4068631943231473).first.id
	end

	def test_find_all_by_result
		assert_equal Array, trans_repo.find_all_by_result('success').class
		assert_equal Array, trans_repo.find_all_by_result('failed').class
		assert_equal Transaction, trans_repo.find_all_by_result('success').first.class
		assert_equal Array.new, trans_repo.find_all_by_result('dog')
		assert_equal 1, trans_repo.find_all_by_result('success').first.id
	end
end