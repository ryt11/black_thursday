require_relative 'merchant'
require 'csv'
require 'pry'
class MerchantRepository
  attr_reader :file, :merchants, :se_inst
  def initialize(file, se_inst)
    @file = file
    @se_inst = se_inst
    @merchants = Hash.new(0)
    merchant_maker
  end

  def open_contents
    CSV.open(file, headers: true, header_converters: :symbol)
  end

  def merchant_maker
    open_contents.each do |row|
      id = row[:id].to_i
      name = row[:name]
      @merchants[id] = Merchant.new({:id => id, :name => name,
        :created_at => Time.parse(row[:created_at])}, self)
    end
  end

  def all
    @merchants.values
  end

  def find_by_id(id)
    @merchants.has_key?(id) ? @merchants[id] : nil

  end

  def find_by_name(naming)
    found_merchant = all.detect do |merchant|
      merchant.name.downcase == naming.downcase
    end
    found_merchant
  end

  def find_all_by_name(fragment)
    found_merchants = @merchants.values.map do |merchant|
      if merchant.name.downcase.include?(fragment.downcase)
        merchant
      end
    end
    found_merchants.compact
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end
