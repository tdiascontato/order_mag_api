# frozen_string_literal: true

module Filters
  extend ActiveSupport::Concern

  def apply_filters
    filters = {}
    filters[:order_id] = params[:order_id] if params[:order_id].present?
    filters[:date] = params[:start_date]..params[:end_date] if params[:start_date].present? && params[:end_date].present?
    filters
  end
end
