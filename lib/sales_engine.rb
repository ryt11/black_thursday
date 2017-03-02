require_relative "merchant_repository"
require_relative "item_repository"
require_relative "invoice_repository"
require_relative "invoice_item_repository"
require_relative "transaction_repository"
require_relative "customer_repository"

class SalesEngine
    attr_accessor :paths, :items, :merchants, :invoices,
    :invoice_items, :transactions, :customers
  def initialize (hash)
    @paths = hash
    @items = make_item_repo unless @paths[:items].nil?
    @merchants = make_merchant_repo unless @paths[:merchants].nil?
    @invoices = make_invoice_repo unless @paths[:invoices].nil?
    @invoice_items = make_inv_items_repo unless @paths[:invoice_items].nil?
    @transactions = make_transaction_repo unless @paths[:transactions].nil?
    @customers = make_customer_repo unless @paths[:customers].nil?
  end

  def make_item_repo
    ItemRepository.new(@paths[:items], self)
  end

  def make_merchant_repo
    MerchantRepository.new(@paths[:merchants], self)
  end

  def make_invoice_repo
    InvoiceRepository.new(@paths[:invoices], self)
  end

  def make_inv_items_repo
    InvoiceItemRepository.new(@paths[:invoice_items], self)
  end

  def make_transaction_repo
    TransactionRepository.new(@paths[:transactions], self)
  end

  def make_customer_repo
    CustomerRepository.new(@paths[:customers], self)
  end

  def self.from_csv(hash)
    files = hash.each_pair do |key, value|
      @paths[key] = value unless value.nil?
    end
    SalesEngine.new(files)
  end
end
