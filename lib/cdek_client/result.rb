module CdekClient
  
  class Result

    attr_reader :response, :data, :errors

    def initialize(response, data, errors = [])
      @response = response
      @data = data
      @errors = errors
    end

    def set_data(data)
      @data = data
    end

    def add_error(error)
      errors.push error
    end

  end
end
