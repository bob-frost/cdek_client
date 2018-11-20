require 'cdek_client/client'

module CdekClient

  extend self

  HOSTS = {
    primary: {
      host: 'integration.cdek.ru',
      port: 443
    }.freeze,
    calculator: {
      host: 'api.cdek.ru',
      port: 443
    }.freeze
  }.freeze

  PATHS = {
    pickup_points:  'pvzlist.php',
    order_statuses: 'status_report_h.php',
    order_infos:    'info_report.php',
    new_orders:     'new_orders.php',
    new_schedule:   'new_schedule.php',
    call_courier:   'call_courier.php',
    delete_orders:  'delete_orders.php',
    orders_print:   'orders_print.php',
    calculate:      'calculator/calculate_price_by_json.php'
  }.freeze

  RESPONSE_NORMALIZATION_RULES = {
    pickup_points: {
      CityCode: :to_i,
      coordX: :to_f,
      coordY: :to_f,
      WeightLimit: {
        WeightMin: :to_f,
        WeightMax: :to_f
      }.freeze
    }.freeze,
    
    order_statuses: {
      DeliveryDate: :to_time,
      ReturnDispatchNumber: :to_i,
      Status: {
        Date: :to_time,
        Code: :to_i,
        CityCode: :to_i,
        State: {
          Date: :to_time,
          Code: :to_i,
          CityCode: :to_i
        }.freeze
      }.freeze,
      Reason: {
        Date: :to_time,
        Code: :to_i
      }.freeze,
      DelayReason: {
        Date: :to_time,
        Code: :to_i,
        State: {
          Date: :to_time,
          Code: :to_i,
          CityCode: :to_i
        }.freeze
      }.freeze,
      Package: {
        Item: {
          DelivAmount: :to_i
        }.freeze
      }.freeze,
      Attempt: {
        ScheduleCode: :to_i
      }.freeze,
      Call: {
        CallGood: {
          Good: {
            Date: :to_date,
            DateDeliv: :to_date
          }.freeze
        }.freeze,
        CallFail: {
          Fail: {
            Date: :to_date,
            ReasonCode: :to_i
          }.freeze
        }.freeze,
        CallDelay: {
          Delay: {
            Date: :to_date,
            DateNext: :to_date
          }.freeze
        }.freeze
      }.freeze
    }.freeze,

    order_infos: {
      Date: :to_date,
      TariffTypeCode: :to_i,
      Weight: :to_f,
      DeliverySum: :to_f,
      DateLastChange: :to_time,
      CashOnDeliv: :to_f,
      CachOnDelivFac: :to_f,
      SendCity: {
        Code: :to_i
      }.freeze,
      RecCity: {
        Code: :to_i
      }.freeze,
      AddedService: {
        ServiceCode: :to_i,
        Sum: :to_f
      }.freeze
    }.freeze,

    calculate: {
      price: :to_f,
      deliveryPeriodMin: :to_i,
      deliveryPeriodMax: :to_i,
      deliveryDateMin: :to_date,
      deliveryDateMax: :to_date,
      tariffId: :to_i,
      cashOnDelivery: :to_f,
      priceByCurrency: :to_f
    }.freeze

  }.freeze

  CALCULATOR_API_VERSION = '1.0'

  TIME_FORMAT = '%Y-%m-%dT%H:%M:%S'

  DATE_FORMAT = '%Y-%m-%d'
  
  def generate_secure(formatted_date, password)
    Digest::MD5.hexdigest("#{formatted_date}&#{password}")
  end

  def format_date(date_or_time)
    format = date_or_time.is_a?(Time) || date_or_time.is_a?(DateTime) ? TIME_FORMAT : DATE_FORMAT
    date_or_time.strftime(format)
  end

end