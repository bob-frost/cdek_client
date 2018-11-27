require 'httparty'
require 'json'

require 'cdek_client/abstract_client'
require 'cdek_client/calculator_errors'
require 'cdek_client/util'

module CdekClient
  
  class CalculatorClient < AbstractClient

    def initialize(account = nil, password = nil, timeout = nil)
      @account = account
      @password = password
      @timeout = timeout
    end

    def calculate(params)
      params = normalize_request_data params
      formatted_date_execute = if params[:dateExecute].is_a?(Date) || params[:dateExecute].is_a?(Time)
        CdekClient.format_date params[:dateExecute]
      elsif !Util.blank? params[:dateExecute]
        params[:dateExecute]
      else
        CdekClient.format_date Date.today
      end
      params.merge!(
        version: CdekClient::CALCULATOR_API_VERSION,
        dateExecute: formatted_date_execute
      )
      if !@account.nil? && !@password.nil?
        params.merge!({
          authLogin: @account,
          secure: CdekClient.generate_secure(formatted_date_execute, @password)
        })
      end
      result = request url_for(:calculator, :calculate), :post, params
      if result.errors.any?
        result.set_data({})
      elsif result.data.has_key?(:error)
        Util.array_wrap(result.data[:error]).each do |error_data|
          error = Calculator.get_api_error error_data[:code], error_data[:text]
          result.add_error error
        end
        result.set_data({})
      else
        normalized_data = normalize_response_data result.data[:result], response_normalization_rules_for(:calculate)
        result.set_data normalized_data
      end
      return result
    end

    private

    def request(url, method, params = {})
      params = params.to_json
      request_params = { 
        headers: { 'Content-Type' => 'application/json' }
      }
      result = raw_request url, method, {}, params
      if !Util.blank? result.data
        data = Util.deep_symbolize_keys JSON.parse(result.data)
        result.set_data data
      end
      result
    end

  end
end
