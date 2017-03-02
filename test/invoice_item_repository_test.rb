require_relative 'test_helper'
require './lib/sales_engine'
require './lib/invoice_item_repository'

class InvoiceItemRepositoryTest < Minitest::Test
	attr_reader :se, :inv_item_repo, :invoices
	def setup
		@se = SalesEngine.from_csv({
  	:items     => "./test/fixtures/item_fixtures.csv",
  	:merchants => "./test/fixtures/merchant_invoice_fixture.csv",
  	:invoices => "./test/fixtures/invoices_fixture.csv",
    :invoice_items => "./test/fixtures/invoice_item_fixture_sa.csv",
    :transactions => "./test/fixtures/transaction_fixture.csv",
    :customers => "./test/fixtures/customer_invoice_fixture.csv"
		})
		@inv_item_repo = se.invoice_items
    @invoices = se.invoices
	end

	def test_it_exists
		assert_equal InvoiceItemRepository, inv_item_repo.class
	end

	def test_invoices_hash_populates
		refute inv_item_repo.invoice_items.empty?
	end

	def test_all_method_returns_array_of_all_invoices
		assert_equal 399, inv_item_repo.all.count
		assert_equal Array, inv_item_repo.all.class
	end

	def test_find_by_id
		assert_equal InvoiceItem, inv_item_repo.find_by_id(12).class
		assert_nil inv_item_repo.find_by_id('bobcat')
	end

	def test_it_can_find_all_by_item_id
    assert_equal InvoiceItem, inv_item_repo.find_all_by_item_id(263395237).first.class
	end

  def test_it_can_find_all_by_invoice_id
    assert_equal InvoiceItem, inv_item_repo.find_all_by_invoice_id(12).first.class
  end
end
