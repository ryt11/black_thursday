require_relative 'test_helper'
require './lib/sales_engine'
require './lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
	attr_reader :se, :sa, :se_two, :sa_two

	def setup
		@se = SalesEngine.from_csv({
  	:items     => "./test/fixtures/item_fixture_sa.csv",
    :merchants => "./test/fixtures/merchant_fixtures.csv",
    :invoice_items => "./test/fixtures/invoice_item_fixture_sa.csv",
  	:transactions => "./test/fixtures/transaction_fixture.csv",
  	:invoices => "./test/fixtures/invoices_fixture.csv"
		})
		@sa = SalesAnalyst.new(se)

		@se_two = SalesEngine.from_csv({:items => "./test/fixtures/item_fixtures.csv",
  	:merchants => "./test/fixtures/merchant_invoice_fixture.csv",
  	:invoices => "./test/fixtures/invoice_fixture_two.csv"})
		@sa_two = SalesAnalyst.new(se_two)
	end

	def test_there_is_a_sales_analyst
		assert_instance_of SalesAnalyst, sa
	end

	def test_that_calculates_avg_items_per_merchant
		assert_equal 1.41, sa.average_items_per_merchant
	end

	def test_it_calculates_diff_btw_mean_and_count_sqrd_summed
		assert_equal 31.04, sa.diff_btw_mean_and_item_c_sqrd_summed
	end

	def test_avg_items_per_merchant_std_deviation
		assert_equal 1.39, sa.average_items_per_merchant_standard_deviation
	end

	def test_high_item_count_in_merchant
		high_item = sa.merchants_with_high_item_count
		assert_equal 1, high_item.count
		assert_equal Merchant, high_item.first.class
		assert_equal 'BowlsByChris', high_item.first.name
		assert_equal 12334145, high_item.first.id
		refute high_item.empty?
	end

	def test_get_whole_merchant_items_set
		assert_equal 17, sa.get_merchant_items_set.count
		assert_equal Array, sa.get_merchant_items_set.class
	end

	def test_avg_item_price_for_a_merchant
		assert_equal BigDecimal, sa.average_item_price_for_merchant(12334145).class
	end

	def test_aggregate_avg_for_avg_price_per_merchant

		se_1 = SalesEngine.from_csv({
    :items     => "./data/items.csv",
    :merchants => "./data/merchants.csv",
    })
		sa_2 = SalesAnalyst.new(se_1)

		assert_equal BigDecimal, sa_2.average_average_price_per_merchant.class
	end

	def test_average_item_price_across_merchants

		assert_equal BigDecimal, sa.average_item_price.class
	end

	def test_item_price_set
		assert_equal Array, sa.get_item_price_set.class
		assert_equal 24, sa.get_item_price_set.count
	end

	def test_diff_mean_and_item_price_sqrd_summed

		assert_equal BigDecimal, sa.difference_between_mean_and_item_price_squared_summed.class
	end

	def test_standard_deviation_avg_items

		assert_equal 211.05, sa.average_item_price_standard_deviation
	end

	def test_golden_items

		name_1 = "New Orleans Mardi Gras 2016 4&#39; by 2&#39; acrylic paintings by local artist"
		assert_equal name_1, sa.golden_items.first.name
		assert_equal 263556752, sa.golden_items.first.id
		assert_equal Array, sa.golden_items.class
	end

	def test_average_invoices_per_merchant

		assert_equal 4.0, sa.average_invoices_per_merchant
	end

	def test_it_can_get_whole_invoice_set
		se_one = SalesEngine.from_csv({
    :items     => "./data/items.csv",
    :merchants => "./data/merchants.csv",
    :invoices => "./data/invoices.csv"
    })
    sa_one = SalesAnalyst.new(se_one)
		assert_equal Array, sa_one.get_merchant_invoices_set.class
		assert_equal 475, sa_one.get_merchant_invoices_set.count
		assert_equal 7, sa_one.get_merchant_invoices_set.last
	end

	def test_difference_between_the_mean_and_invoice_count_sqrd_summed
		assert_equal 251, sa.difference_between_mean_and_invoice_count_squared_summed
	end

	def test_average_invoices_per_merchant_std_deviation
		assert_equal 3.96, sa.average_invoices_per_merchant_standard_deviation
	end

	def test_the_top_merchants_by_invoice_count_returned

		assert_equal 1, sa_two.top_merchants_by_invoice_count.count
		assert_equal 'jejum', sa_two.top_merchants_by_invoice_count.first.name
		assert_equal 17, sa_two.top_merchants_by_invoice_count.first.invoices.count
	end

	def test_bottom_merchants_by_invoice_count
	 assert_equal 0, sa_two.bottom_merchants_by_invoice_count.count
 end
 def test_invoice_status_returns_percentage
	 pending = sa.invoice_status(:pending)
	 returned = sa.invoice_status(:returned)
	 shipped = sa.invoice_status(:shipped)
	 sum = shipped + pending + returned
	 assert_equal 29.41, pending
	 assert_equal Float, pending.class
	 assert_equal 11.76, returned
	 assert_equal 58.82, shipped
	 assert_equal 0.0, sa.invoice_status(:hamster)
	 assert sum > 99.99
 end

 def test_it_gets_wday
	 assert_equal Array, sa.get_wdays.class
	 assert_equal 68, sa.get_wdays.count
 end

 def test_average_invoices_per_day

	 assert_equal 9.71, sa.average_invoices_per_day
	 assert_equal Float, sa.average_invoices_per_day.class
 end

 def test_gets_diff_btw_mean_and_day_freq_and_sums

	 assert_equal 69.43, sa.diff_btw_mean_and_day_frequency_sqrd_summed
	 assert_equal Float, sa.diff_btw_mean_and_day_frequency_sqrd_summed.class
 end

 def test_it_gets_standard_dev_by_freq_per_day

	 assert_equal 3.4, sa.average_frequency_per_day_standard_deviation
	 assert_equal Float, sa.average_frequency_per_day_standard_deviation.class
 end

 def test_it_gets_top_days_by_invoice_count

	 assert_equal 2, sa.top_days_by_invoice_count.count
	 assert_equal ["Saturday", "Thursday"], sa.top_days_by_invoice_count
	 assert_equal Array, sa.top_days_by_invoice_count.class
	 assert_equal String, sa.top_days_by_invoice_count.first.class
 end

 def test_it_knows_total_revenue_by_date
   assert_equal 0, sa.total_revenue_by_date(Time.parse("2004-02-14"))
 end

 def test_can_get_hash_of_merchant_invoice_totals
   merch_inv_totals = sa.merchant_invoice_totals
   assert_equal Hash, merch_inv_totals.class
   assert_equal Merchant, merch_inv_totals.keys.first.class
   assert_equal BigDecimal, merch_inv_totals.values.first.class
 end

 def test_it_can_rank_merchants_by_revenue
   top_merchants = sa.top_revenue_earners(5)
   assert_equal 5, top_merchants.count
   assert_equal "Shopin1901", top_merchants.first.name
 end

 def test_it_can_find_merchants_with_pending_invoices
   pending_invoices = sa.merchants_with_pending_invoices
   assert_equal 3, pending_invoices.count
   assert_equal Merchant, pending_invoices.last.class
 end

 def test_it_can_find_merchants_with_one_item
   one_item_merchants = sa.merchants_with_only_one_item
   assert_equal 1, one_item_merchants.first.items.count
   assert_equal Merchant, one_item_merchants.first.class
 end

 def test_it_can_find_merchants_with_only_one_item_registered_in_month
   one_item_in_month = sa.merchants_with_only_one_item_registered_in_month("January")
   assert_equal "DesignerEstore", one_item_in_month.first.name
   assert_equal Merchant, one_item_in_month.first.class
 end

 def test_it_can_find_revenue_by_merchant
   assert_equal BigDecimal, merch_rev = sa.revenue_by_merchant(12334105).class
 end

 def test_it_can_find_most_sold_item_for_merchants
   most_sold = sa.most_sold_item_for_merchant(12334105)
   assert_equal 1, most_sold.count
   assert_equal Item, most_sold.first.class
 end

 def test_it_can_find_invoice_items
   paid_invoices = sa.find_invoice_items(se.merchants.find_by_id(12334105).invoices)
   assert_equal 6, paid_invoices.count
   assert_equal InvoiceItem, paid_invoices.first.class
   assert_equal 344, paid_invoices.first.id
 end

 def test_it_can_add_quantity_of_invoice_item
   sold_count = Hash.new(0)
   paid_invoices = sa.find_invoice_items(se.merchants.find_by_id(12334105).invoices)
   quantity_hash = sa.add_quantity_of_invoice_item(paid_invoices, sold_count)
   assert_equal Hash, quantity_hash.class
   assert_equal Array, quantity_hash.first.class
 end

 def test_it_can_find_high_item_ids
   sold_count = Hash.new(0)
   paid_invoices = sa.find_invoice_items(se.merchants.find_by_id(12334105).invoices)
   hash = sa.add_quantity_of_invoice_item(paid_invoices, sold_count)
   result = sa.find_high_item_ids(hash)
   assert_equal Hash, result.class
   assert_equal 10, result.values.first
 end

 def test_it_can_find_highest_items_by_id
   sold_count = Hash.new(0)
   paid_invoices = sa.find_invoice_items(se.merchants.find_by_id(12334105).invoices)
   hash = sa.add_quantity_of_invoice_item(paid_invoices, sold_count)
   expected = sa.find_high_item_ids(hash)
   result = sa.find_highest_items_by_id(expected)
   assert_equal Array, result.class
   assert_equal Item, result.first.class
   assert_equal 263543136, result.first.id
 end

 def test_it_can_find_invoices_for_merchant
   found = sa.find_invoices_for_merchant(12334105)
   assert_equal Array, found.class
   assert_equal Invoice, found.first.class
 end

 def test_it_can_find_paid_in_full_invoice_items_for_merchant
    found_inv = sa.find_invoices_for_merchant(12334105)
    result = sa.find_invoice_items_for_merchant(found_inv)
    assert_equal Array, result.class
    assert_equal InvoiceItem, result.first.class
 end

 def test_we_can_populate_price_hash
   found_inv = sa.find_invoices_for_merchant(12334105)
   inv_items = sa.find_invoice_items_for_merchant(found_inv)
   expected = sa.add_price_of_invoice_item(inv_items)
   assert_equal Hash, expected.class
   assert_equal BigDecimal, expected.values.first.class
 end

 def test_it_can_get_best_item_for_merchant
   expected = sa.best_item_for_merchant(12334105)
   assert_equal Item, expected.class
   assert_equal 263500126, expected.id
 end


end
