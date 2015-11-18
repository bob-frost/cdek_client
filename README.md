# CdekClient

Ruby клиент для API службы доставки СДЭК ([www.edostavka.com](http://www.edostavka.com)).

## Установка

Добавить в Gemfile:

    gem 'cdek_client'
    
И выполнить:

    $ bundle

Или установить вручную:

    $ gem install cdek_client

## Начало работы

Создать инстанс класса `CdekClient::Client`:

```ruby
client = CdekClient::Client.new ВАШ_ЛОГИН, ВАШ_ПАРОЛЬ
```

Вызовы возвращают объект класса `CdekClient::Result`. Результат хранится в атрибуте `data`, ошибки (если присутствуют) в `errors`. Полный результат запроса ([HTTParty](https://github.com/jnunemaker/httparty)) можно получить из атрибута `response`. Например: 

```ruby
result = client.pickup_points cityid: 44
result.errors.any? # => false
result.data.length # => 20
result.data.each do |pickup_point|
  puts "#{pickup_point[:Code]} #{pickup_point[:Name]}"
end

result = client.pickup_points cityid: 9999
result.data.length # => 0
result.errors.inspect # => [#<CdekClient::PvzNotfoundError>]
```

## Ошибки

Классы ошибок наследуют от `CdekClient::Error`:

* StandardError
  * CdekClient::Error
    * CdekClient::ResponseError
    * CdekClient::APIError
      * CdekClient::AttributeEmptyError
      * CdekClient::AuthError
      * CdekClient::BarcodeDublError
      * etc ...
    * CdekClient::Calculator::Error
      * CdekClient::Calculator::APIError
        * CdekClient::Calculator::ApiVersionError
        * CdekClient::Calculator::AuthError
        * CdekClient::Calculator::DeliveryImpossibleError
        * etc ...

Например:

```ruby
# CdekClient::ResponseError
error.code # => 500
error.message # => internal server error

# Дочерние классы CdekClient::APIError
error.class # => CdekClient::AttributeEmptyError
error.code # => ERR_ATTRIBUTE_EMPTY
error.message # => Не задано значение атрибута:NUMBER

# Дочерние классы CdekClient::Calculator::APIError
error.class # => CdekClient::Calculator::DeliveryImpossibleError
error.code # => 3
error.message # => Невозможно осуществить доставку по этому направлению при заданных условиях
```

Для получения полного списка ошибок API ознакомьтесь с [официальной документацией к API](http://www.edostavka.ru/clients/integrator.html). Список классов ошибок можно найти в [lib/cdek_client/errors.rb](lib/cdek_client/errors.rb) и [lib/cdek_client/calculator_errors.rb](lib/cdek_client/calculator_errors.rb ). 

## Методы

Для получения детальной информации о формате передаваемых и возвращаемых данных ознакомьтесь с [официальной документацией к API](http://www.edostavka.ru/clients/integrator.html).

Даты и время можно передавать как объекты класса `Date` и `Time`, так и как строки в форматах `%Y-%m-%d` и `%Y-%m-%dT%H:%M:%S`.

#### Список пунктов самовывоза

```ruby
client.pickup_points
client.pickup_points filter_params
```

Формат параметров:

```ruby
{
  cityid: 44,
  citypostcode: 656065
}
```

#### Список заказов на доставку

```ruby
client.new_orders params
```

Формат параметров:

```ruby
{
  Number: 'Номер акта приема-передачи',
  Order: [
    {
      Number: 'Номер отправления клиента',
      SendCityCode: 16196,
      RecCityCode: 270,
      RecipientName: 'John Doe',
      Phone: '123-456-789',
      TariffTypeCode: 1,
      # etc ...
      Address: {
        Street: 'Некая улица',
        House: '123',
        Flat: '456'
        PvzCode: 'ABC123'
      },
      Package: [
        {
          Number: 'Номер упаковки',
          Barcode: 'Штрих-код упаковки',
          Weight: 10,
          SizeA: 100,
          SizeB: 100,
          SizeC: 100,
          Item: [
            {
              WareKey: 'Артикул товара',
              Cost: 100,
              Payment: 0,
              Weight: 1,
              Amount: 1,
              Comment: 'Наименование товара'
            },
            {
              WareKey: 'Артикул товара 2'
              # etc ...
            }
          ]
        },
        {
          Number: 'Номер упаковки 2'
          # etc ...
        }
      ],
      AddService: {
        ServiceCode: 2
      }
    },
    {
      Number: 'Номер отправления 2'
      # etc ...
    }
  ]
}
```

Параметры `Order`, `Package` и `Item` могут быть хешем или массивом хешей, т.е.:

```ruby
Order: { }
# или
Order: [{}, {}, ...]
```

#### Прозвон получателя

```ruby
client.new_schedule params
```

Формат параметров:

```ruby
{
  Order: [
    {
      DispatchNumber: 'Номер отправления СДЭК',
      Number: 'Номер отправления клиента',
      Date: Date.today,
      Attempt: {
        Date: Date.today,
        RecipientName: 'John Doe',
        # etc ...
        Address: {
          Street: 'Некая улица',
          House: '123',
          Flat: '456',
          # etc ...
          Package: [
            {
              Number: 'Номер упаковки',
              Item: [
                {
                  WareKey: 'Артикул товара',
                  Payment: 100
                },
                {
                  WareKey: 'Артикул товара 2'
                  Payment: 200
                },
                # etc ...
              ]
            },
            {
              Number: 'Номер упаковки 2',
              # etc ...
            },
            # etc ...
          ]
        }
      }
    },
    {
      DispatchNumber: 'Номер отправления СДЭК 2',
      # etc ...
    },
    # etc ...
  ]
}
```

Параметры `Order`, `Package` и `Item` могут быть хешем или массивом хешей.

#### Вызов курьера

```ruby
client.call_courier params
```

Формат параметров:

```ruby
{
  Call: [
    {
      Date: Date.today,
      SendCityCode: 65,
      TimeBeg: '12:00',
      TimeEnd: '16:00',
      SenderName: 'John Doe',
      SendPhone: '123-456-789',
      # etc ...
      Address: {
        Street: 'Некая улица',
        House: '123',
        Flat: '456'
      } 
    },
    {
      Date: Date.today.next_day,
      # etc ...
    },
    # etc ...
  ]
```

Параметр `Call` может быть хешем или массивом хешей.

#### Список заказов на удаление

```ruby
client.delete_orders params
```

Формат параметров:

```ruby
{
  Number: 'Номер акта приема-передачи',
  Order: [
    { Number: 'Номер отправления клиента 1' },
    { Number: 'Номер отправления клиента 2' },
    # etc ...
  ]
```

Параметр `Order` может быть хешем или массивом хешей.

#### Статусы заказов

```ruby
client.order_statuses
client.order_statuses filter_params
```

Формат параметров:

```ruby
{
  ShowHistory: 1,
  ChangePeriod: {
    DateFirst: Date.today,
    DateLast: Date.today
  },
  Order: {
    DispatchNumber: 'Номер отправления СДЭК',
    Number: 'Номер отправления клиента',
    Date: Date.today
  }
}
```

#### Информация по заказам

```ruby
client.order_infos filter_params
```

Формат параметров:

```ruby
{
  ChangePeriod: {
    DateBeg: Date.today,
    DateEnd: Date.today
  },
  Order: {
    DispatchNumber: 'Номер отправления СДЭК',
    Number: 'Номер отправления клиента',
    Date: Date.today
  }
}
```

#### Печатная форма квитанции к заказу

```ruby
client.orders_print params
```

Формат параметров:
```ruby
{
  CopyCount: 1,
  Order: {
    DispatchNumber: 'Номер отправления СДЭК',
    Number: 'Номер отправления клиента',
    Date: Date.today
  }
}
```

Параметр `Order` может быть хешем или массивом хешей.

Пример использования:

```ruby
result = client.orders_print Order: { DispatchNumber: '123456' }
if result.errors.any?
  result.errors.each do |e|
    puts "#{e.code} - #{e.message}"
  end
else
  file_path = '/path/to/file.pdf'
  File.open(file_path, 'w') { |f| f.write result.data }
end
```

#### Расчёт стоимости доставки

```ruby
client.calculate_price params
```

Формат параметров:

```ruby
{
  dateExecute: Date.today,
  senderCityId: 270,
  receiverCityId: 44,
  tariffId: 137,
  tariffList: [
    # ...
  ],
  modeId: 1,
  goods: [
    {
      weight: 1,
      length: 1,
      width: 1,
      height: 1,
      # или
      volume: 1
    },
    # etc ...
  ]
}
```

Использование калькулятора без авторизации:

```ruby
calculator = CdekClient::CalculatorClient.new
result = calculator.calculate params
```

## TODO

- Тесты
- Улучшить преобразование xml в хеш и отрефакторить обработку получаемых данных

## Ссылки

- [www.edostavka.ru](http://www.edostavka.ru/) - Сайт СДЭК.
- [www.edostavka.ru/clients/integrator.html](http://www.edostavka.ru/clients/integrator.html/) - Документация к API.


Разработано при поддержке интернет-магазина настольных игр "[Танго и Кэш](http://tango-cash.ru/)"
