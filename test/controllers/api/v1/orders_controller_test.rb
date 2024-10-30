require "test_helper"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @valid_file = fixture_file_upload('data_txt.txt', 'text/plain')
    @invalid_file = nil
    @order_id = 100
  end

  test "should upload orders successfully with valid file" do
    post '/api/v1/orders', params: { 'data_txt': @valid_file }
    assert_response :success
    assert JSON.parse(response.body).is_a?(Array)
  end

  test "should return bad request for upload_orders with missing file" do
    post '/api/v1/orders', params: { 'data_txt': @invalid_file }
    assert_response :bad_request
    assert_equal 'Empty!', JSON.parse(response.body)['error']
  end

  test "should retrieve specific order by id successfully" do
    post '/api/v1/orders/id', params: { data_txt: @valid_file, order_id: @order_id }
    assert_response :success
    parsed_response = JSON.parse(response.body)
    assert_equal @order_id, parsed_response['order_id']
    assert parsed_response['products'].is_a?(Array)
  end

  test "should return bad request for order_id with missing file or order_id" do
    post '/api/v1/orders/id', params: { data_txt: @invalid_file, order_id: @order_id }
    assert_response :bad_request
    assert_equal 'Empty!', JSON.parse(response.body)['error']
  end

  test "should return not found for order_id with non-existent order_id" do
    post '/api/v1/orders/id', params: { data_txt: @valid_file, order_id: 99999 }
    assert_response :not_found
    assert_equal 'Order not found', JSON.parse(response.body)['error']
  end

  test "should retrieve orders within date range successfully" do
    start_date = '20210302'
    end_date = '20210306'
    post '/api/v1/orders/filters', params: { data_txt: @valid_file, start_date: start_date, end_date: end_date }
    assert_response :success
    assert JSON.parse(response.body).is_a?(Array)
  end

  test "should return bad request for orders_filtered with missing file or date range" do
    post '/api/v1/orders/filters', params: { data_txt: @invalid_file, start_date: '20210302', end_date: '20210306' }
    assert_response :bad_request
    assert_equal 'Empty!', JSON.parse(response.body)['error']
  end
end
