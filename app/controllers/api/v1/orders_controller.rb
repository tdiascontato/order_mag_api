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

    render json: data, status: 200
  end

  def order_id
    file = params[:data_txt]
    order_id = params[:order_id]&.to_i
    # order = Order.includes(:products).find_by(user_id)
    if file.nil? || order_id.nil?
      render json: { error: 'Empty!' }, status: :bad_request
      return
    end

    parsed_order_id = parse_file_id(file, order_id)
    if parsed_order_id
      render json: parsed_order_id, status: :ok
    else
      render json: { error: 'Order not found' }, status: :not_found
    end

  end

  def orders_filtered
    file = params[:data_txt]
    start_date = params[:start_date]
    end_date = params[:end_date]

    if file.nil? || start_date.nil? || end_date.nil?
      render json: { error: 'Empty!' }, status: :bad_request
      return
    end

    date_range = Date.parse(start_date)..Date.parse(end_date)
    parsed_orders = parse_file_dates(file, date_range)
    data = data_formated(parsed_orders)

    render json: data
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
