require 'httparty'
require 'nokogiri'

require 'cdek_client'
require 'cdek_client/errors'
require 'cdek_client/result'
require 'cdek_client/util'

module CdekClient
  class AbstractClient

    protected

    def url_for(host_key, path_key)
      URI.join("http://#{CdekClient::HOSTS[host_key][:host]}:#{CdekClient::HOSTS[host_key][:port]}", CdekClient::PATHS[path_key]).to_s
    end

    def response_normalization_rules_for(key)
      CdekClient::RESPONSE_NORMALIZATION_RULES[key]
    end

    def normalize_request_data(data)
      case data
      when Hash
        result = {}
        data.each do |key, value|
          result[key.to_sym] = normalize_request_data(value)
        end
        return result
      when Array
        result = []
        data.each do |value|
          result.push normalize_request_data(value)
        end
        return result
      when Date, Time
        return CdekClient.format_date data
      else
        return data
      end
    end

    def normalize_response_data(data, rules, keypath = [])
      if data.nil? || (data.is_a?(String) && data.strip.empty?)
        return nil
      end

      case data
      when Hash
        result = {}
        data.each do |key, value|
          key = key.to_sym
          result[key] = normalize_response_data(value, rules, keypath + [key])
        end
        return result
      when Array
        result = []
        data.each do |value|
          result.push normalize_response_data(value, rules, keypath)
        end
        return result
      else
        rule = rules.nil? ? nil : Util.hash_value_at_keypath(rules, keypath)
        case rule
        when :to_i, :to_f
          return data.send rule
        when :to_date
          begin
            return Date.parse data
          rescue ArgumentError => e
            puts "Couldn't parse date '#{data}' at #{keypath.join '.'} with #{e.class.name}: #{e.message}!"
            return data
          end
        when :to_time
          begin
            return Time.parse data
          rescue ArgumentError => e
            puts "Couldn't parse time '#{data}' at #{keypath.join '.'} with #{e.class.name}: #{e.message}!"
            return data
          end
        else
          return data
        end
      end
    end

    def raw_request(url, retry_url, method, request_params, params)
      if !Util.blank?(params)
        if method == :post
          request_params = request_params.merge body: params
        else
          request_params = request_params.merge query: params
        end
      end

      begin
        response = HTTParty.send method, url, request_params
        if response.code == 200
          return CdekClient::Result.new response, response.body
        else
          raise CdekClient::ResponseError.new response.code, response.message
        end
      rescue CdekClient::ResponseError, HTTParty::ResponseError => e
        if Util.blank? retry_url
          error = e.is_a?(CdekClient::ResponseError) ? e : (CdekClient::ResponseError.new e.response.code, e.response.message)
          return CdekClient::Result.new response, response.body, [error]
        else
          return raw_request url, nil, method, request_params, nil
        end
      rescue Timeout::Error, Errno::ETIMEDOUT => e
        if Util.blank? retry_url
          return CdekClient::Result.new response, response.body, [e]
        else
          return raw_request url, nil, method, request_params, nil
        end
      end
    end

  end
end
