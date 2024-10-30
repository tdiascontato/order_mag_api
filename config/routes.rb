Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/orders/:id', to: 'orders#order_id'

      post '/orders/filters', to: 'orders#orders_filtered'
      post '/orders', to: 'orders#upload_orders'
    end
  end
end
