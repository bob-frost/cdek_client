require 'cdek_client/errors'

module CdekClient
  module Calculator

    class Error < CdekClient::Error; end

    class APIError < Error; end

    class UnkownAPIError < APIError; end

    class ServerError < APIError; end

    class ApiVersionError < APIError; end

    class AuthError < APIError; end

    class DeliveryImpossibleError < APIError; end

    class PlaceParamsError < APIError; end

    class PlaceEmptyError < APIError; end

    class TariffEmptyError < APIError; end

    class SenderCityEmptyError < APIError; end

    class ReceiverCityEmptyError < APIError; end

    class DateEmptyError < APIError; end

    class DeliveryTypeError < APIError; end

    class FormatError < APIError; end

    class DecodeError < APIError; end

    class SenderPostcodeNotFoundError < APIError; end

    class SenderPostcodeAmbigiousError < APIError; end

    class ReceiverPostcodeNotFoundError < APIError; end

    class ReceiverPostcodeAmbigiousError < APIError; end

    def self.get_api_error(code, message)
      code = code.to_i if !code.is_a?(Integer) && code.to_s =~ /^\d+$/ 
      klass = API_ERROR_MAPPINGS[code] || UnkownAPIError
      klass.new code, message
    end

    API_ERROR_MAPPINGS = {
      0 => ServerError,
      1 => ApiVersionError,
      2 => AuthError,
      3 => DeliveryImpossibleError,
      4 => PlaceParamsError,
      5 => PlaceEmptyError,
      6 => TariffEmptyError,
      7 => SenderCityEmptyError,
      8 => ReceiverCityEmptyError,
      9 => DateEmptyError,
      10 => DeliveryTypeError,
      11 => FormatError,
      12 => DecodeError,
      13 => SenderPostcodeNotFoundError,
      14 => SenderPostcodeAmbigiousError,
      15 => ReceiverPostcodeNotFoundError,
      16 => ReceiverPostcodeAmbigiousError
    }

  end
end
