require 'httparty'
require 'nokogiri'

require 'cdek_client/abstract_client'
require 'cdek_client/calculator_client'
require 'cdek_client/util'

module CdekClient
  class Client < AbstractClient

    def initialize(account = nil, password = nil)
      @account = account
      @password = password
    end

    def pickup_points(params = {})
      params = normalize_request_data params
      result = request url_for(:primary, :pickup_points), url_for(:secondary, :pickup_points), :get, params
      if result.errors.any?
        result.set_data []
        return result
      end
      if result.data[:PvzList].has_key? :ErrorCode
        error = CdekClient.get_api_error result.data[:PvzList][:ErrorCode], result.data[:PvzList][:Msg]
        result.add_error error
        result.set_data []
      else
        normalized_data = Util.array_wrap result.data[:PvzList][:Pvz]
        normalized_data = normalize_response_data normalized_data, response_normalization_rules_for(:pickup_points)
        result.set_data normalized_data
      end
      result
    end

    def order_statuses(params = {})
      params = normalize_request_data params
      params = { StatusReport: params }
      result = authorized_request url_for(:primary, :order_statuses), url_for(:secondary, :order_statuses), params
      if result.errors.any?
        result.set_data []
        return result
      end
      if result.data[:StatusReport].has_key? :ErrorCode
        error = CdekClient.get_api_error result.data[:StatusReport][:ErrorCode], result.data[:StatusReport][:Msg]
        result.add_error error
        result.set_data []
      else
        normalized_data = Util.array_wrap result.data[:StatusReport][:Order]
        normalized_data = normalize_response_data normalized_data, response_normalization_rules_for(:order_statuses)
        result.set_data normalized_data
      end
      result
    end

    def order_infos(params)
      params = normalize_request_data params
      params = { InfoRequest: params }
      result = authorized_request url_for(:primary, :order_infos), url_for(:secondary, :order_infos), params
      if result.errors.any?
        result.set_data []
        return result
      end
      if result.data.has_key? :response
        result.data[:response].values.each do |error_data|
          error = CdekClient.get_api_error error_data[:ErrorCode], error_data[:Msg]
          result.add_error error
        end
        result.set_data []
      elsif result.data.has_key?(:InfoReport) && result.data[:InfoReport].is_a?(Hash)
        normalized_data = Util.array_wrap result.data[:InfoReport][:Order]
        normalized_data = normalize_response_data normalized_data, response_normalization_rules_for(:order_infos)
        result.set_data normalized_data
      else
        result.set_data []
      end
      result
    end

    def new_orders(params)
      params = normalize_request_data params
      params[:OrderCount] = params[:Order].is_a?(Array) ? params[:Order].length : 1
      params = { DeliveryRequest: params }
      result = authorized_request url_for(:primary, :new_orders), url_for(:secondary, :new_orders), params
      if result.errors.any?
        result.set_data []
        return result
      end
      normalized_data = []
      if result.data[:response].has_key? :DeliveryRequest
        Util.array_wrap(result.data[:response][:DeliveryRequest]).each do |error_data|
          error = CdekClient.get_api_error error_data[:ErrorCode], error_data[:Msg]
          result.add_error error
        end
      end
      if result.data[:response].has_key? :Order
        Util.array_wrap(result.data[:response][:Order]).each do |order_data|
          if order_data.has_key? :ErrorCode
            error = CdekClient.get_api_error order_data[:ErrorCode], order_data[:Msg]
            result.add_error error
          elsif order_data.has_key? :Number
            normalized_order_data = normalize_response_data order_data, response_normalization_rules_for(:new_orders)
            normalized_data.push normalized_order_data
          end
        end
      end
      result.set_data normalized_data
      result
    end

    def new_schedule(params)
      params = normalize_request_data params
      params[:OrderCount] = params[:Order].is_a?(Array) ? params[:Order].length : 1
      params = { ScheduleRequest: params }
      result = authorized_request url_for(:primary, :new_schedule), url_for(:secondary, :new_schedule), params
      if result.errors.any?
        result.set_data []
        return result
      end
      normalized_data = []
      if result.data[:response].has_key? :Order
        Util.array_wrap(result.data[:response][:Order]).each do |error_data|
          error = CdekClient.get_api_error error_data[:ErrorCode], error_data[:Msg]
          result.add_error error
        end
      end
      if result.data[:response].has_key? :ScheduleRequest
        Util.array_wrap(result.data[:response][:ScheduleRequest]).each do |schedule_data|
          if schedule_data.has_key? :ErrorCode
            error = CdekClient.get_api_error schedule_data[:ErrorCode], schedule_data[:Msg]
            result.add_error error
          elsif schedule_data.has_key? :Msg
            normalized_schedule_data = normalize_response_data schedule_data, response_normalization_rules_for(:new_schedule)
            normalized_data.push normalized_schedule_data
          end
        end
      end
      result.set_data normalized_data
      result
    end

    def call_courier(params)
      params = normalize_request_data params
      params[:CallCount] = params[:Call].is_a?(Array) ? params[:Call].length : 1
      params = { CallCourier: params }
      result = authorized_request url_for(:primary, :call_courier), url_for(:secondary, :call_courier), params
      if result.errors.any?
        result.set_data []
        return result
      end
      normalized_data = []
      if result.data[:response].has_key? :CallCourier
        Util.array_wrap(result.data[:response][:CallCourier]).each do |error_data|
          next unless error_data.has_key?(:ErrorCode)
          error = CdekClient.get_api_error error_data[:ErrorCode], error_data[:Msg]
          result.add_error error
        end
      end
      if result.data[:response].has_key? :Call
        Util.array_wrap(result.data[:response][:Call]).each do |call_data|
          if call_data.has_key? :ErrorCode
            error = CdekClient.get_api_error call_data[:ErrorCode], call_data[:Msg]
            result.add_error error
          elsif call_data.has_key? :Number
            normalized_call_data = normalize_response_data call_data, response_normalization_rules_for(:call_courier)
            normalized_data.push normalized_call_data
          end
        end
      end
      result.set_data normalized_data
      result
    end

    def delete_orders(params)
      params = normalize_request_data params
      params[:OrderCount] = params[:Order].is_a?(Array) ? params[:Order].length : 1
      params = { DeleteRequest: params }
      result = authorized_request url_for(:primary, :delete_orders), url_for(:secondary, :delete_orders), params
      # Currently API returns '500 - internal server error' for some invalid requests here.
      # Continue processing data if it is such error but response data is present 
      if result.errors.any? && (result.errors.length > 1 || result.errors[0].code != 500 || !result.data.is_a?(Hash) || !result.data.has_key?(:response))
        result.set_data []
        return result
      end

      normalized_data = []
      Util.array_wrap(result.data[:response][:DeleteRequest]).each do |delete_data|
        if delete_data.has_key? :ErrorCode
          error = CdekClient.get_api_error delete_data[:ErrorCode], delete_data[:Msg]
          result.add_error error
        elsif delete_data.has_key? :Number
          normalized_delete_data = normalize_response_data delete_data, response_normalization_rules_for(:delete_orders)
          normalized_data.push normalized_delete_data
        end
      end
      result.set_data normalized_data
      result
    end

    def orders_print(params)
      params = normalize_request_data params
      params[:OrderCount] = params[:Order].is_a?(Array) ? params[:Order].length : 1
      params = build_authorized_request_params OrdersPrint: params
      result = raw_request url_for(:primary, :orders_print), url_for(:secondary, :orders_print), :post, {}, params
      errors_hash = Util.xml_to_hash(result.data) rescue nil
      if !errors_hash.nil? && errors_hash.has_key?(:response)
        [:OrdersPrint, :Order].each do |key|
          Util.array_wrap(errors_hash[:response][key]).each do |error_data|
            next unless error_data.has_key?(:ErrorCode)
            error = CdekClient.get_api_error error_data[:ErrorCode], error_data[:Msg]
            result.add_error error
          end
        end
        result.set_data nil
      end
      result
    end

    def calculate_price(params)
      calculator.calculate params
    end

    private

    def authorized_request(url, retry_url, params = {})
      params = build_authorized_request_params params
      request url, retry_url, :post, params
    end

    def request(url, retry_url, method, params = {})
      result = raw_request url, retry_url, method, {}, params
      if !Util.blank? result.data
        result.set_data Util.xml_to_hash(result.data)
      end
      result
    end

    def build_authorized_request_params(params)
      root_key = params.keys.first
      formatted_date = CdekClient.format_date Time.now.utc 
      secure = CdekClient.generate_secure formatted_date, @password
      params = {
        root_key => params[root_key].merge(
          Date: formatted_date,
          Account: @account,
          Secure: secure
        )
      }
      { xml_request: Util.hash_to_xml(params) }
    end

    def calculator
      @calculator ||= CalculatorClient.new @account, @password
    end

  end
end
