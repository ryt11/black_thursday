  require 'pry'
  class SalesAnalyst
  attr_reader :se_inst

  def initialize(se_inst)
    @se_inst = se_inst
  end

  def average_items_per_merchant
    (se_inst.items.all.count.to_f / se_inst.merchants.all.count.to_f).round(2)
  end

  def diff_btw_mean_and_item_c_sqrd_summed
    mean = average_items_per_merchant
    get_merchant_items_set.map { |item_c| (item_c - mean) ** 2 }.reduce(:+).round(2)
  end

  def get_merchant_items_set
    se_inst.merchants.all.map { |merchant| merchant.items.count }
  end

  def average_items_per_merchant_standard_deviation
    set_length = (get_merchant_items_set.length - 1)
    Math.sqrt(diff_btw_mean_and_item_c_sqrd_summed/set_length).round(2)
  end

  def merchants_with_high_item_count
    avg = average_items_per_merchant
    std_dev = (average_items_per_merchant_standard_deviation)
    se_inst.merchants.all.select do |merchant|
      merchant.items.count >= (std_dev + avg)
    end
  end

  def average_item_price_for_merchant(merchant_id)
    item_list = se_inst.merchants.find_by_id(merchant_id).items
    (item_list.reduce(0.0) do |price_total, item|
      price_total + item.unit_price
    end / item_list.size).round(2)
  end

  def average_average_price_per_merchant
    merch_avgs = se_inst.merchants.all.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    (merch_avgs.reduce(:+)/merch_avgs.count).round(2)
  end

  def average_item_price
    all_items = se_inst.items.all
    all_items.reduce(0.0) do |total, item|
      ((total + item.unit_price) / all_items.count.to_f).round(2)
    end
  end

  def get_item_price_set
    se_inst.items.all.map {|item| item.unit_price}
  end

  def difference_between_mean_and_item_price_squared_summed
    mean = average_item_price
    get_item_price_set.map do |item_price|
      (item_price - mean) ** 2
    end.reduce(:+).round(2)
  end

  def average_item_price_standard_deviation
    set_length = (get_item_price_set.length - 1)
    diff = difference_between_mean_and_item_price_squared_summed
    Math.sqrt(diff/set_length).round(2)
  end

  def golden_items
    avg = average_item_price
    std_dev = average_item_price_standard_deviation
    se_inst.items.all.select {|item| item.unit_price >= (avg + (std_dev * 2)) }
  end

  def average_invoices_per_merchant
    avg_inv = se_inst.invoices.all.count.to_f
    (avg_inv / se_inst.merchants.all.count.to_f).round(2)
  end

  def get_merchant_invoices_set
    se_inst.merchants.all.map do |merchant|
      se_inst.invoices.find_all_by_merchant_id(merchant.id).count
    end
  end

  def difference_between_mean_and_invoice_count_squared_summed
    mean = average_invoices_per_merchant
    get_merchant_invoices_set.map do |invoices|
      (invoices - mean) ** 2
    end.reduce(:+).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    set_length = (get_merchant_invoices_set.count - 1)
    sum = difference_between_mean_and_invoice_count_squared_summed
    Math.sqrt(sum/set_length).round(2)
  end

  def top_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    avg = average_invoices_per_merchant
    se_inst.merchants.all.select do |merchant|
      merchant.invoices.count >= (avg + (std_dev * 2))
    end
  end

  def bottom_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    avg = average_invoices_per_merchant
    se_inst.merchants.all.select do |merchant|
      merchant.invoices.count <= (avg - (std_dev * 2))
    end
  end

  def invoice_status(status)
    status_count = se_inst.invoices.all.count do |invoice|
      invoice.status == status
    end
    (100 * status_count.to_f / se_inst.invoices.all.count.to_f).round(2)
  end

  def get_wdays
    se_inst.invoices.all.map do |invoice|
      invoice.created_at.wday
    end
  end

  def days_of_the_week
    {"Sunday" => 0,
   "Monday" => 1,
   "Tuesday" => 2,
   "Wednesday" => 3,
   "Thursday" => 4,
   "Friday" => 5,
   "Saturday" => 6
    }.invert
  end

  def frequency_created_per_day
    day_count = Hash.new(0)
      get_wdays.each do |wday_num|
      day_count[days_of_the_week[wday_num]] += 1
    end
    day_count
  end

  def average_invoices_per_day
    frequencies = frequency_created_per_day.values
    (frequencies.reduce(:+).to_f / frequencies.count.to_f).round(2)
  end

  def diff_btw_mean_and_day_frequency_sqrd_summed
    mean = average_invoices_per_day
    frequency_created_per_day.values.map do |day_freq|
      (day_freq - mean) ** 2
    end.reduce(:+).round(2)
  end

  def average_frequency_per_day_standard_deviation
    set_length = (frequency_created_per_day.values.count - 1)
    Math.sqrt(diff_btw_mean_and_day_frequency_sqrd_summed/set_length).round(2)
  end

  def top_days_by_invoice_count
    avg = average_invoices_per_day
    std_dev = average_frequency_per_day_standard_deviation
    frequency_created_per_day.select do |day, frequency|
      frequency >= (std_dev + avg)
    end.keys
  end

  def find_invoices_by_date(date)
      se_inst.invoices.all.select do |invoice|
        invoice.created_at.strftime("%Y-%m-%d") == date.strftime("%Y-%m-%d")
      end
  end

  def total_revenue_by_date(date)
    found_invoices = find_invoices_by_date(date)
    found_invoices.reduce(0) { |sum, invoice| sum += invoice.total }
  end

  def merchant_invoice_totals
    merchants_total_hash = Hash.new(0)
     selection = se_inst.invoices
     se_inst.merchants.all.each do |merchant|
      invoices = selection.find_all_by_merchant_id(merchant.id)
       merchants_total_hash[merchant] += invoices.reduce(0) do |sum, invoice|
         sum += invoice.total
       end
     end
     merchants_total_hash
  end

  def top_revenue_earners(x = 20)
     whats_this = merchant_invoice_totals.sort_by do |k, v|
      v
    end.reverse.to_h.keys[0...x]
  end

  def merchants_ranked_by_revenue
    merchant_invoice_totals.sort_by {|k, v| v}.reverse.to_h.keys
  end

  def merchants_with_pending_invoices
    invoices = se_inst.invoices.all.select do |invoice|
      !invoice.is_paid_in_full? == true
    end
      invoices.map do |invoice|
        se_inst.merchants.find_by_id(invoice.merchant_id)
      end.uniq
  end

  def merchants_with_only_one_item
    se_inst.merchants.all.select {|merchant| merchant.items.count == 1}
  end

  def merchants_with_only_one_item_registered_in_month(month)
    month_merchants = se_inst.merchants.all.select do |merchant|
      merchant.created_at.strftime("%B").downcase == month.downcase
    end
    month_merchants.select do |merchant|
      merchant.items.count == 1
    end
  end

  def revenue_by_merchant(merchant_id)
    found_invoices = se_inst.merchants.find_by_id(merchant_id).invoices
    found_invoices.map do |invoice|
      invoice.total
    end.reduce(:+)
  end

  def most_sold_item_for_merchant(merchant_id)
    sold_count = Hash.new(0)
    invoices = se_inst.merchants.find_by_id(merchant_id).invoices
    find_invoice_items(invoices)
    ph = add_quantity_of_invoice_item(find_invoice_items(invoices), sold_count)
    find_highest_items_by_id(find_high_item_ids(ph))
  end

    def find_invoice_items(invoices)
    invoice_items = invoices.map do |invoice|
      if invoice.is_paid_in_full?
        se_inst.invoice_items.find_all_by_invoice_id(invoice.id)
        else
          next
        end
      end.flatten(1).compact
    end

  def add_quantity_of_invoice_item(invoice_items, sold_count)
    invoice_items.each do |item|
      sold_count[item.item_id] += item.quantity
    end
    sold_count
  end

  def find_high_item_ids(sold_count)
    sold_count.select do |k, v|
      k if v == sold_count.values.max
    end
  end

  def find_highest_items_by_id(ids)
      ids.keys.map do |item_id|
      se_inst.items.find_by_id(item_id)
    end
  end

  def find_invoices_for_merchant(merchant_id)
    se_inst.merchants.find_by_id(merchant_id).invoices
  end

  def find_invoice_items_for_merchant (invoices)
    se = se_inst.invoice_items
    invoices.map do |inv|
        inv.is_paid_in_full? ? se.find_all_by_invoice_id(inv.id) : next
    end.flatten(1).compact
  end

  def add_price_of_invoice_item(inv_items)
    revenue_count = Hash.new(0)
    inv_items.each do |item|
      revenue_count[item.item_id] += (item.quantity * item.unit_price)
    end
    revenue_count
  end

  def best_item_for_merchant(merchant_id)
    invoices = find_invoices_for_merchant(merchant_id)
    inv_items = find_invoice_items_for_merchant(invoices)
    revenue_count = add_price_of_invoice_item(inv_items)
    high_revenue_items = revenue_count.select do |k, v|
      k if v == revenue_count.values.max
    end
    se_inst.items.find_by_id(high_revenue_items.keys[0])

  end

end
