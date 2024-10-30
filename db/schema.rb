ActiveRecord::Schema[7.1].define(version: 2024_10_30_123020) do
  create_table "orders", force: :cascade do |t|
    t.integer "order_id"
    t.integer "user_id", null: false
    t.decimal "total"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "product_id"
    t.decimal "value"
    t.integer "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_products_on_order_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "orders", "users"
  add_foreign_key "products", "orders"
end
