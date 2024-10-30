# frozen_string_literal: true

module FileParser
  extend ActiveSupport::Concern

  def parse_file(file)
    orders = []
    file.read.each_line do |line|
      orders << parse_line(line)
    end
    orders
  end

  def parse_file_dates(file, date_range)
    orders = []
    file.read.each_line do |line|
      order = parse_line(line)

      orders << order if date_range.cover?(order[:date])
    end
    orders
  end

  def parse_file_id(file, order_id)
    products = []
    order_date = nil
    total_value = 0.0

    file.read.each_line do |line|
      order = parse_line(line)

      if order[:order_id] == order_id
        order_date ||= order[:date]
        total_value += order[:value]
        products << { product_id: order[:product_id], value: format('%.2f', order[:value]) }
      end
    end

    return nil if products.empty?

    {
      order_id: order_id,
      date: order_date.strftime('%Y-%m-%d'),
      total: total_value.round(2),
      products: products
    } #Cuidado com strftime
  end

  private
  def parse_line(line)
    {
      user_id: line[0..9].to_i,
      name: line[10..54].strip,
      order_id: line[55..64].to_i,
      product_id: line[65..74].to_i,
      value: line[75..86].to_f,
      date: Date.strptime(line[87..94], '%Y%m%d')
    }
  end

end
