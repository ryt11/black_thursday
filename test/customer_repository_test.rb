require_relative 'test_helper'
require './lib/sales_engine'
require './lib/transaction_repository'

class CustomerRepositoryTest < Minitest::Test 
	attr_reader :se, :cust_repo
	def setup
		@se = SalesEngine.from_csv({
  	:customers => "./test/fixtures/customer_repository_fixture.csv",
		})
		@cust_repo = se.customers
	end

	def test_it_exists
		assert_equal CustomerRepository, cust_repo.class
	end

	def test_customers_hash_populates
		refute cust_repo.customers.empty?
	end

	def test_all_method_returns_array_of_all_customers
		assert_equal 149, cust_repo.all.count
		assert_equal Array, cust_repo.all.class
	end

	def test_find_by_id	
		assert_equal Customer, cust_repo.find_by_id(12).class
		assert_nil cust_repo.find_by_id('horse')
	end

	def test_find_all_by_first_name
		assert_equal Array, cust_repo.find_all_by_first_name('Heber').class
		assert_equal Array, cust_repo.find_all_by_first_name('Parker').class
		assert_equal Customer, cust_repo.find_all_by_first_name('Dejon').first.class
		assert_equal [], cust_repo.find_all_by_first_name('catepillar')
		assert_equal 'Casimer', cust_repo.find_all_by_first_name('CAsimer').first.first_name
	end

	def test_find_all_by_last_name
		assert_equal Array, cust_repo.find_all_by_last_name('Osinski').class
		assert_equal Array, cust_repo.find_all_by_last_name('Braun').class
		assert_equal Customer, cust_repo.find_all_by_last_name('Kris').first.class
		assert_equal [], cust_repo.find_all_by_last_name('Yule')
		assert_equal 'Pfannerstill', cust_repo.find_all_by_last_name('pfannerstiLL').first.last_name
	end
end