require_relative 'invoice_item'
require 'csv'
require 'pry'
require 'bigdecimal'
class InvoiceItemRepository
  attr_reader :file, :invoice_items, :se_inst
  def initialize(file, se_inst)
    @file = file
    @se_inst = se_inst
    @invoice_items = Hash.new(0)
    invoice_item_maker
  end

  def open_contents
    CSV.open(file, headers: true, header_converters: :symbol)
  end

  def invoice_item_maker
    open_contents.each do |row|
      id = row[:id].to_i
      invoice_items[id] = InvoiceItem.new({:id => id,
        :item_id => row[:item_id].to_i, :invoice_id => row[:invoice_id].to_i,
        :quantity => row[:quantity].to_i,
        :unit_price => BigDecimal.new(row[:unit_price].to_i)/100,
        :created_at => Time.parse(row[:created_at]),
        :updated_at => Time.parse(row[:updated_at])}, self)
    end
  end

  def all
    invoice_items.values
  end

  def find_by_id(id)
    invoice_items.has_key?(id) ? invoice_items[id] : nil
  end

  def find_all_by_item_id(item_id)
      all.select do |invoice_item|
        invoice_item.item_id == item_id.to_i
      end
  end

  def find_all_by_invoice_id(invoice_id)
    all.select do |invoice_item|
      invoice_item.invoice_id == invoice_id.to_i
    end

  end

  def inspect
    "#<#{self.class} #{@invoice_items.size} rows>"
  end
end
