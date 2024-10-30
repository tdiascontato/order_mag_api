class Api::V1::OrdersController < ApplicationController
  include FileParser
  include Filters
  def upload_orders
    file = params[:data_txt]
    if file.nil?
      render json: { error: 'Empty!' }, status: :bad_request
      return
    end
    parsed_orders = parse_file(file)
    Rails.logger.info(parsed_orders.inspect) #log
    data = data_formated(parsed_orders)

    render json: data
  end

  def order_id
    order = Order.includes(:products).find_by(id: params[:id])

    if order.nil?
      render json: { error: 'Order not found' }, status: :not_found
    else
      render json: data_formated([order])
    end
  end

  def orders_filtered
    orders = Order.all.includes(:products).where(apply_filters)
    render json: data_formated(orders)
  end

  private
  def data_formated(orders)
    orders.group_by { |order| [order[:user_id], order[:name]] }.map do |(user_id, name), user_orders|
      {
        user_id: user_id,
        name: name,
        orders: user_orders.group_by { |order| [order[:order_id], order[:date]] }.map do |(order_id, date), products|
          {
            order_id: order_id,
            date: date.strftime('%Y-%m-%d'),
            total: products.sum { |product| product[:value] }.round(2),
            products: products.map { |product| { product_id: product[:product_id], value: format('%.2f', product[:value]) } }
          }
        end
      }
    end
  end

end
