require_relative 'test_helper'
require './lib/sales_engine'
require './lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test
	attr_reader :se, :mr
	def setup
		@se = SalesEngine.from_csv({
  	:items     => "./data/items.csv",
  	:merchants => "./data/merchants.csv",
		})
		@mr = se.merchants
	end

	def test_that_merchant_maker_returns_a_populated_hash
		refute mr.merchants.empty?
		assert_equal Hash, mr.merchants.class
	end

	def test_all_method_returns_array_of_all_merchants
		assert_equal 475, mr.all.count
		assert_equal Array, mr.all.class
	end

	def test_find_by_id
		assert_equal Merchant, mr.find_by_id(12334105).class
		assert_nil mr.find_by_id('hedgehog')
	end

	def test_it_can_find_by_name
		assert_equal Merchant, mr.find_by_name("Shopin1901").class
	end

	def test_it_can_find_all_by_name
		result = mr.find_all_by_name('shopin')
		assert_equal Array, result.class
		assert_equal 1, result.count
	end
end
