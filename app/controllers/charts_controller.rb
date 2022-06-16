# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :check_user_signed, only: %i[show new edit update destroy index]
  def index; end

  def create
    params_hash = params.to_unsafe_h
    @start_date1 = params_hash['/charts?method=post'].fetch('start_date(1i)')
    @start_date2 = params_hash['/charts?method=post'].fetch('start_date(2i)')
    @start_date3 = params_hash['/charts?method=post'].fetch('start_date(3i)')
    @end_date1 = params_hash['/charts?method=post'].fetch('end_date(1i)')
    @end_date2 = params_hash['/charts?method=post'].fetch('end_date(2i)')
    @end_date3 = params_hash['/charts?method=post'].fetch('end_date(3i)')
    @object_for_analyze = params_hash['/charts?method=post'].fetch('object_for_analyze')
    @type_of_chart = params_hash['/charts?method=post'].fetch('type_of_chart')
    # @start_date = params_hash['/charts?method=post'].fetch('start_date')
    @start_date = Date.civil(@start_date1.to_i, @start_date2.to_i, @start_date3.to_i)
    # @end_date = params_hash['/charts?method=post'].fetch('end_date')
    @end_date = Date.civil(@end_date1.to_i, @end_date2.to_i, @end_date3.to_i)
    @chart_data = if @object_for_analyze == 'Expences'
                    OperationDetail.joins('INNER JOIN expences on expences.id =operation_details.expence_id')
                                   .joins(:operation).where(operation: { user_id: current_user.id })
                                   .where('date BETWEEN ? AND ?',
                                          @start_date.present? ? @start_date : DateTime.new(2022, 1, 1, 0, 0, 0), @end_date.present? ? @end_date : DateTime.new(2100, 1, 1, 0, 0, 0))
                                   .group(:name).sum(:amount)
                                   .sort_by { |_key, value| value }.reverse.to_h
                  else
                    OperationDetail.joins('INNER JOIN incomes on incomes.id =operation_details.income_id')
                                   .joins(:operation).where(operation: { user_id: current_user.id })
                                   .where('date BETWEEN ? AND ?',
                                          @start_date.present? ? @start_date : DateTime.new(2022, 1, 1, 0, 0, 0), @end_date.present? ? @end_date : DateTime.new(2100, 1, 1, 0, 0, 0))
                                   .group(:name).sum(:amount)
                                   .sort_by { |_key, value| value }.reverse.to_h
                  end
    render template: 'charts/index'
  end

  def show
    # binding.pry
    # @planned_expences_current_month = planned_current_month
    # @balance = balance
    # @spent_current_month = spent_current_month
    # @incomes_current_month = incomes_current_month
    # @expences_chart_data = OperationDetail.joins('INNER JOIN expences on expences.id =operation_details.expence_id')
    #                                       .joins(:operation).where(operation: { user_id: current_user.id })
    #                                       .where('date BETWEEN ? AND ?', Date.current.beginning_of_month, Date.current.end_of_month)
    #                                       .group(:name).sum(:amount)
    #                                       .sort_by { |_key, value| value }.reverse.to_h
    # @incomes_chart_data = OperationDetail.joins('INNER JOIN incomes on incomes.id =operation_details.income_id')
    #                                      .joins(:operation).where(operation: { user_id: current_user.id })
    #                                      .where('date BETWEEN ? AND ?', Date.current.beginning_of_month, Date.current.end_of_month)
    #                                      .group(:name).sum(:amount)
    #                                      .sort_by { |_key, value| value }.reverse.to_h
  end

  private

  def check_user_signed
    render template: 'welcome/index' unless user_signed_in?
  end

  def spent_current_month
    OperationDetail.joins(:operation).where(operation: { user_id: current_user.id })
                   .where(operation: { operation_type: 0 })
                   .where('date BETWEEN ? AND ?', Date.current.beginning_of_month, Date.current.end_of_month)
                   .sum(:amount)
  end

  def incomes_current_month
    OperationDetail.joins(:operation).where(operation: { user_id: current_user.id })
                   .where(operation: { operation_type: 1 })
                   .where('date BETWEEN ? AND ?', Date.current.beginning_of_month, Date.current.end_of_month)
                   .sum(:amount)
  end

  def planned_current_month
    PlannedExpence.with_user(current_user.id)
                  .where('date BETWEEN ? AND ?', Date.current.beginning_of_month, Date.current.end_of_month).sum(:amount)
  end

  def balance
    OperationDetail.joins(:operation).where(operation: { user_id: current_user.id })
                   .where(operation: { operation_type: 1 })
                   .where('date  <= ?', Date.current.end_of_day)
                   .sum(:amount) -
      OperationDetail.joins(:operation).where(operation: { user_id: current_user.id })
                     .where(operation: { operation_type: 0 })
                     .where('date  <= ?', Date.current.end_of_day)
                     .sum(:amount)
  end
end
