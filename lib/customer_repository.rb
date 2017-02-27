require_relative 'customer'
require 'csv'
require 'pry'
require 'bigdecimal'
require 'time'

class CustomerRepository
  attr_reader :file, :customers, :sales_engine_instance
  def initialize(file, sales_engine_instance)
    @file = file
    @sales_engine_instance = sales_engine_instance
    @customers = Hash.new(0)
    customer_maker
  end

  def open_contents
    CSV.open(file, headers: true, header_converters: :symbol)
  end

  def customer_maker
    open_contents.each do |row|
    @customers[row[:id].to_i] = Customer.new({:id => row[:id].to_i, :first_name => row[:first_name], :last_name => row[:last_name],
    :created_at => Time.parse(row[:created_at]), :updated_at => Time.parse(row[:updated_at])}, self)
    end

  end

  def all
    customers.values
  end

  def find_by_id(id)
    customers.has_key?(id) ? customers[id] : nil
  end

  def find_all_by_first_name(name_fragment)
      found_customers = all.select do |customer|
         customer.first_name.downcase.include?(name_fragment.downcase) ? customer.first_name : next
      end
      found_customers.compact
  end

  def find_all_by_last_name(name_fragment)
    found_customers = all.select do |customer|
       customer.last_name.downcase.include?(name_fragment.downcase) ? customer.last_name : next
    end
    found_customers.compact
  end

  def inspect
    "#<#{self.class} #{@customers.size} rows>"
    #possibly need to change @merchants to @customers, check harness
  end
end
