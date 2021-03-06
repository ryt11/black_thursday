require_relative 'transaction'
require 'csv'
require 'pry'


class TransactionRepository
  attr_reader :file, :transactions, :se_inst
  def initialize(file, se_inst)
    @file = file
    @se_inst = se_inst
    @transactions = Hash.new(0)
    transaction_maker
  end

  def open_contents
    CSV.open(file, headers: true, header_converters: :symbol)
  end

  def transaction_maker
    open_contents.each do |row|
      id = row[:id].to_i
      transactions[id] = Transaction.new({:id => id, :credit_card_number =>
        row[:credit_card_number].to_i, :invoice_id => row[:invoice_id].to_i,
        :credit_card_expiration_date => row[:credit_card_expiration_date],
        :result => row[:result], :created_at => Time.parse(row[:created_at]),
        :updated_at => Time.parse(row[:updated_at])}, self)
    end
  end

  def all
    transactions.values
  end

  def find_by_id(id)
    transactions.has_key?(id) ? transactions[id] : nil
  end

  def find_all_by_invoice_id(invoice_id)
      all.select do |transaction|
      transaction.invoice_id == invoice_id.to_i
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
      all.select do |transaction|
      transaction.credit_card_number == credit_card_number.to_i
    end
  end

  def find_all_by_result(result)
      all.select do |transaction|
      transaction.result == result.downcase
    end
  end

  def inspect
    "#<#{self.class} #{@transactions.size} rows>"
  end
end
