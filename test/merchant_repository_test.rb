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
		mr.merchant_maker
		refute mr.merchants.empty?
		assert_equal Hash, mr.merchants.class
	end

	def test_all_method_returns_array_of_all_merchants
		mr.merchant_maker
		assert_equal 475, mr.all.count
		assert_equal Array, mr.all.class
	end

	def test_find_by_id
		mr.merchant_maker
		assert_equal Merchant, mr.find_by_id(12334105).class
		# Merchant:0x007fad81930a68
		assert_nil mr.find_by_id('hedgehog')
	end

	def test_find_by_name_case_insensitive_search
		skip
		mr.merchant_maker
		# result = mr.find_by_name("jejum")
		assert_equal 'JEJUM', mr.find_by_name('jejum')
	end

	def test_can_find_another_name_case_insensitive
		skip
		mr.merchant_maker
		assert_equal 'THEPURPLEPENSHOP', mr.find_by_name('thepurplepenshop')
		assert_equal 'THEPURPLEPENSHOP', mr.find_by_name('thePURPLEpenshop')
	end

	def test_it_can_find_by_name
		mr.merchant_maker
		assert_equal Merchant, mr.find_by_name("Shopin1901").class
	end

	def test_it_can_find_all_by_name
		mr.merchant_maker
		expected = ["SHOPIN1901", "THEPURPLEPENSHOP", "WOODENPENSHOP", "ZAZABOUTIQUESHOP", "SOUDOVESHOP", "WOODLEYSHOP", "EXECUTIVEGIFTSHOPPE", "CHALKLEYSWOODSHOP", "FRENCHIEZSHOP", "SIMCHACENTRALSHOP", "SHOPDIXIECHICKEN", "BEBRAVESHOP", "SHOP20161", "SHOPTIMECREATIONS", "MAKOSMOMSBLANKETSHOP", "MANDYBLACKSHOP", "RETROPOSTERSHOP", "SHOPATPINKFLAMINGO", "SHOPAMO", "KAWAIIANSHOP", "BISHOPSWOODCRAFT", "FUNTIMEWORKSHOP", "MATTSNERDSHOPPE", "SHOPKARISSA", "KAMLANDSOAPSHOP", "RANAPARVASHOP"]

		result = mr.find_all_by_name('shop')
		assert_equal Array, result.class
		assert_equal expected, result 
	end

end