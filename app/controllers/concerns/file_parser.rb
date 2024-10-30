# frozen_string_literal: true

module FileParser
  extend ActiveSupport::Concern

  def parse_file(file)
    orders = []
    file.read.each_line do |line|
      # contagem pelo tamanho de cada campo dado
      orders << {
        user_id: line[0..9].to_i,
        name: line[10..54].strip,
        order_id: line[55..64].to_i,
        product_id: line[65..74].to_i,
        value: line[75..86].to_f,
        date: Date.strptime(line[87..94], '%Y%m%d')
      }
    end
    orders
  end
end
