module CdekClient
  
  class Error < StandardError

    attr_reader :code, :message

    def initialize(code, message)
      @code = code
      @message = message
    end

  end

  class ResponseError < Error; end

  class APIError < Error; end

  class UnkownAPIError < APIError; end

  class AttributeEmptyError < APIError; end

  class AuthError < APIError; end

  class BarcodeDublError < APIError; end

  class CallcourierCityError < APIError; end

  class CallcourierCountError < APIError; end

  class CallcourierDatetimeError < APIError; end

  class CallcourierDateDublError < APIError; end

  class CallcourierDateExistsError < APIError; end

  class CallcourierTimeError < APIError; end

  class CallcourierTimelunchError < APIError; end

  class CallcourierTimeIntervalError < APIError; end

  class CallDublError < APIError; end

  class CashLimitError < APIError; end

  class CashNoError < APIError; end

  class DatabaseError < APIError; end

  class DatabaseTestError < APIError; end

  class DateformatError < APIError; end

  class DateinvoiceError < APIError; end

  class DboAuthError < APIError; end

  class DboAuthHashError < APIError; end

  class DboCityIncorrectForServiceError < APIError; end

  class DboClientCurrencyError < APIError; end

  class DboDateCreateInvalidError < APIError; end

  class DboForbiddenSumForCashError < APIError; end

  class DboIncorrectUrlError < APIError; end

  class DboInvalidAdditionalserviceError < APIError; end

  class DboNeedAuthError < APIError; end

  class DboNotFoundError < APIError; end

  class DboPackageNumberEmptyError < APIError; end

  class DboParamEmptyError < APIError; end

  class DboParamMistakeError < APIError; end

  class DboParamMistakePvzError < APIError; end

  class DboParamServiceInterfaceError < APIError; end

  class DboPayerEmptyError < APIError; end

  class DboReceiverAddressTitleEmptyError < APIError; end

  class DboReceiverCityAmbiguousError < APIError; end

  class DboReceiverCityEmptyError < APIError; end

  class DboReceiverCityIncorrectError < APIError; end

  class DboReceiverCityNotIntegerError < APIError; end

  class DboResultEmptyError < APIError; end

  class DboResultServiceEmptyError < APIError; end

  class DboSenderAddressTitleEmptyError < APIError; end

  class DboSenderCityAmbiguousError < APIError; end

  class DboSenderCityEmptyError < APIError; end

  class DboSenderCityIncorrectError < APIError; end

  class DboSenderCityNotIntegerError < APIError; end

  class DboServiceEmptyError < APIError; end

  class DboTypeEmptyError < APIError; end

  class DboWeightEmptyError < APIError; end

  class DeleterequestOrderError < APIError; end

  class DeleterequestOrderActnumberError < APIError; end

  class DeleterequestOrderDeletedError < APIError; end

  class DeleterequestOrderMoveError < APIError; end

  class FileNotexistsError < APIError; end

  class FileSaveError < APIError; end

  class FirstDublExistsError < APIError; end

  class InforequestError < APIError; end

  class InforequestDatebegError < APIError; end

  class InvalidAddressDeliveryError < APIError; end

  class InvalidAmountError < APIError; end

  class InvalidCostError < APIError; end

  class InvalidCostexError < APIError; end

  class InvalidDeliveryrecipientcostError < APIError; end

  class InvalidDispachnumberError < APIError; end

  class InvalidIntakeserviceError < APIError; end

  class InvalidIntakeserviceTocityError < APIError; end

  class InvalidNumberError < APIError; end

  class InvalidNumberDeleteError < APIError; end

  class InvalidPaymentError < APIError; end

  class InvalidPaymentexError < APIError; end

  class InvalidServicecodeError < APIError; end

  class InvalidSizeError < APIError; end

  class InvalidTarifftypecodeError < APIError; end

  class InvalidWeightError < APIError; end

  class InvalidXmlError < APIError; end

  class ItemNotfindError < APIError; end

  class NeedAttributeError < APIError; end

  class NotfoundcurrencyError < APIError; end

  class NotfoundtagError < APIError; end

  class NotEqualCallcountError < APIError; end

  class NotEqualOrdercountError < APIError; end

  class NotFoundCostexError < APIError; end

  class NotFoundPassportnumberError < APIError; end

  class NotFoundPaymentexError < APIError; end

  class NotFoundReccityError < APIError; end

  class NotFoundRegistrationaddressError < APIError; end

  class NotFoundSendcityError < APIError; end

  class NotFoundTarifftypecodeError < APIError; end

  class NotValidPassportnumberError < APIError; end

  class OrderCountError < APIError; end

  class OrderDeleteError < APIError; end

  class OrderDublError < APIError; end

  class OrderDublExistsError < APIError; end

  class OrderNotfindError < APIError; end

  class OrdersNotFoundError < APIError; end

  class PackageNotfindError < APIError; end

  class PackageNumDublError < APIError; end

  class PrintOrderError < APIError; end

  class PvzcodeError < APIError; end

  class PvzcodeNotfoundError < APIError; end

  class PvzClosedError < APIError; end

  class PvzNotfoundError < APIError; end

  class PvzNotfoundByPostcodeError < APIError; end

  class PvzWeightError < APIError; end

  class PvzWeightLimitError < APIError; end

  class ReccitycodeError < APIError; end

  class ReccitypostcodeError < APIError; end

  class ReccitypostcodeDublError < APIError; end

  class ScheduleChangeError < APIError; end

  class ScheduleDateError < APIError; end

  class ScheduleDublError < APIError; end

  class SendcitycodeError < APIError; end

  class SendcitypostcodeError < APIError; end

  class SendcitypostcodeDublError < APIError; end

  class UnknownDocTypeError < APIError; end

  class UnknownVersionError < APIError; end

  class WarekeyDublError < APIError; end

  class WeightLimitError < APIError; end

  class XmlEmptyError < APIError; end

  def get_api_error(code, message)
    klass = API_ERROR_MAPPINGS[code.to_sym] || UnkownAPIError
    klass.new code, message
  end

  API_ERROR_MAPPINGS = {
    ERR_API: APIError,
    ERR_ATTRIBUTE_EMPTY: AttributeEmptyError,
    ERR_AUTH: AuthError,
    ERR_BARCODE_DUBL: BarcodeDublError,
    ERR_CALLCOURIER_CITY: CallcourierCityError,
    ERR_CALLCOURIER_COUNT: CallcourierCountError,
    ERR_CALLCOURIER_DATETIME: CallcourierDatetimeError,
    ERR_CALLCOURIER_DATE_DUBL: CallcourierDateDublError,
    ERR_CALLCOURIER_DATE_EXISTS: CallcourierDateExistsError,
    ERR_CALLCOURIER_TIME: CallcourierTimeError,
    ERR_CALLCOURIER_TIMELUNCH: CallcourierTimelunchError,
    ERR_CALLCOURIER_TIME_INTERVAL: CallcourierTimeIntervalError,
    ERR_CALL_DUBL: CallDublError,
    ERR_CASH_LIMIT: CashLimitError,
    ERR_CASH_NO: CashNoError,
    ERR_DATABASE: DatabaseError,
    ERR_DATABASE_test: DatabaseTestError,
    ERR_DATEFORMAT: DateformatError,
    ERR_DATEINVOICE: DateinvoiceError,
    ERR_DBO_AUTH: DboAuthError,
    ERR_DBO_AUTH_HASH: DboAuthHashError,
    ERR_DBO_CITY_INCORRECT_FOR_SERVICE: DboCityIncorrectForServiceError,
    ERR_DBO_CLIENT_CURRENCY: DboClientCurrencyError,
    ERR_DBO_DATE_CREATE_INVALID: DboDateCreateInvalidError,
    ERR_DBO_FORBIDDEN_SUM_FOR_CASH: DboForbiddenSumForCashError,
    ERR_DBO_INCORRECT_URL: DboIncorrectUrlError,
    ERR_DBO_INVALID_ADDITIONALSERVICE: DboInvalidAdditionalserviceError,
    ERR_DBO_NEED_AUTH: DboNeedAuthError,
    ERR_DBO_NOT_FOUND: DboNotFoundError,
    ERR_DBO_PACKAGE_NUMBER_EMPTY: DboPackageNumberEmptyError,
    ERR_DBO_PARAM_EMPTY: DboParamEmptyError,
    ERR_DBO_PARAM_MISTAKE: DboParamMistakeError,
    ERR_DBO_PARAM_MISTAKE_PVZ: DboParamMistakePvzError,
    ERR_DBO_PARAM_SERVICE_INTERFACE: DboParamServiceInterfaceError,
    ERR_DBO_PAYER_EMPTY: DboPayerEmptyError,
    ERR_DBO_RECEIVER_ADDRESS_TITLE_EMPTY: DboReceiverAddressTitleEmptyError,
    ERR_DBO_RECEIVER_CITY_AMBIGUOUS: DboReceiverCityAmbiguousError,
    ERR_DBO_RECEIVER_CITY_EMPTY: DboReceiverCityEmptyError,
    ERR_DBO_RECEIVER_CITY_INCORRECT: DboReceiverCityIncorrectError,
    ERR_DBO_RECEIVER_CITY_NOT_INTEGER: DboReceiverCityNotIntegerError,
    ERR_DBO_RESULT_EMPTY: DboResultEmptyError,
    ERR_DBO_RESULT_SERVICE_EMPTY: DboResultServiceEmptyError,
    ERR_DBO_SENDER_ADDRESS_TITLE_EMPTY: DboSenderAddressTitleEmptyError,
    ERR_DBO_SENDER_CITY_AMBIGUOUS: DboSenderCityAmbiguousError,
    ERR_DBO_SENDER_CITY_EMPTY: DboSenderCityEmptyError,
    ERR_DBO_SENDER_CITY_INCORRECT: DboSenderCityIncorrectError,
    ERR_DBO_SENDER_CITY_NOT_INTEGER: DboSenderCityNotIntegerError,
    ERR_DBO_SERVICE_EMPTY: DboServiceEmptyError,
    ERR_DBO_TYPE_EMPTY: DboTypeEmptyError,
    ERR_DBO_WEIGHT_EMPTY: DboWeightEmptyError,
    ERR_DELETEREQUEST_ORDER: DeleterequestOrderError,
    ERR_DELETEREQUEST_ORDER_ACTNUMBER: DeleterequestOrderActnumberError,
    ERR_DELETEREQUEST_ORDER_DELETED: DeleterequestOrderDeletedError,
    ERR_DELETEREQUEST_ORDER_MOVE: DeleterequestOrderMoveError,
    ERR_FILE_NOTEXISTS: FileNotexistsError,
    ERR_FILE_SAVE: FileSaveError,
    ERR_FIRST_DUBL_EXISTS: FirstDublExistsError,
    ERR_INFOREQUEST: InforequestError,
    ERR_INFOREQUEST_DATEBEG: InforequestDatebegError,
    ERR_INVALID_ADDRESS_DELIVERY: InvalidAddressDeliveryError,
    ERR_INVALID_AMOUNT: InvalidAmountError,
    ERR_INVALID_COST: InvalidCostError,
    ERR_INVALID_COSTEX: InvalidCostexError,
    ERR_INVALID_DELIVERYRECIPIENTCOST: InvalidDeliveryrecipientcostError,
    ERR_INVALID_DISPACHNUMBER: InvalidDispachnumberError,
    ERR_INVALID_INTAKESERVICE: InvalidIntakeserviceError,
    ERR_INVALID_INTAKESERVICE_TOCITY: InvalidIntakeserviceTocityError,
    ERR_INVALID_NUMBER: InvalidNumberError,
    ERR_INVALID_NUMBER_DELETE: InvalidNumberDeleteError,
    ERR_INVALID_PAYMENT: InvalidPaymentError,
    ERR_INVALID_PAYMENTEX: InvalidPaymentexError,
    ERR_INVALID_SERVICECODE: InvalidServicecodeError,
    ERR_INVALID_SIZE: InvalidSizeError,
    ERR_INVALID_TARIFFTYPECODE: InvalidTarifftypecodeError,
    ERR_INVALID_WEIGHT: InvalidWeightError,
    ERR_INVALID_XML: InvalidXmlError,
    ERR_ITEM_NOTFIND: ItemNotfindError,
    ERR_NEED_ATTRIBUTE: NeedAttributeError,
    ERR_NOTFOUNDCURRENCY: NotfoundcurrencyError,
    ERR_NOTFOUNDTAG: NotfoundtagError,
    ERR_NOT_EQUAL_CALLCOUNT: NotEqualCallcountError,
    ERR_NOT_EQUAL_ORDERCOUNT: NotEqualOrdercountError,
    ERR_NOT_FOUND_COSTEX: NotFoundCostexError,
    ERR_NOT_FOUND_PASSPORTNUMBER: NotFoundPassportnumberError,
    ERR_NOT_FOUND_PAYMENTEX: NotFoundPaymentexError,
    ERR_NOT_FOUND_RECCITY: NotFoundReccityError,
    ERR_NOT_FOUND_REGISTRATIONADDRESS: NotFoundRegistrationaddressError,
    ERR_NOT_FOUND_SENDCITY: NotFoundSendcityError,
    ERR_NOT_FOUND_TARIFFTYPECODE: NotFoundTarifftypecodeError,
    ERR_NOT_VALID_PASSPORTNUMBER: NotValidPassportnumberError,
    ERR_ORDER_COUNT: OrderCountError,
    ERR_ORDER_DELETE: OrderDeleteError,
    ERR_ORDER_DUBL: OrderDublError,
    ERR_ORDER_DUBL_EXISTS: OrderDublExistsError,
    ERR_ORDER_NOTFIND: OrderNotfindError,
    ERR_ORDERS_NOT_FOUND: OrdersNotFoundError,
    ERR_PACKAGE_NOTFIND: PackageNotfindError,
    ERR_PACKAGE_NUM_DUBL: PackageNumDublError,
    ERR_PRINT_ORDER: PrintOrderError,
    ERR_PVZCODE: PvzcodeError,
    ERR_PVZCODE_NOTFOUND: PvzcodeNotfoundError,
    ERR_PVZ_CLOSED: PvzClosedError,
    ERR_PVZ_NOTFOUND: PvzNotfoundError,
    ERR_PVZ_NOTFOUND_BY_POSTCODE: PvzNotfoundByPostcodeError,
    ERR_PVZ_WEIGHT: PvzWeightError,
    ERR_PVZ_WEIGHT_LIMIT: PvzWeightLimitError,
    ERR_RECCITYCODE: ReccitycodeError,
    ERR_RECCITYPOSTCODE: ReccitypostcodeError,
    ERR_RECCITYPOSTCODE_DUBL: ReccitypostcodeDublError,
    ERR_SCHEDULE_CHANGE: ScheduleChangeError,
    ERR_SCHEDULE_DATE: ScheduleDateError,
    ERR_SCHEDULE_DUBL: ScheduleDublError,
    ERR_SENDCITYCODE: SendcitycodeError,
    ERR_SENDCITYPOSTCODE: SendcitypostcodeError,
    ERR_SENDCITYPOSTCODE_DUBL: SendcitypostcodeDublError,
    ERR_UNKNOWN_DOC_TYPE: UnknownDocTypeError,
    ERR_UNKNOWN_VERSION: UnknownVersionError,
    ERR_WAREKEY_DUBL: WarekeyDublError,
    ERR_WEIGHT_LIMIT: WeightLimitError,
    ERR_XML_EMPTY: XmlEmptyError
  }

end
