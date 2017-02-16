module DNS
  class BaseService
    attr_accessor :errors, :result

    def initialize
      @errors = []
      @result = []
    end

    def result?
      result.any?
    end

    def errors?
      errors.any?
    end

    protected
    def add_error(e)
      if e.is_a?(Array)
        @errors = e
      else
        @errors << e
      end
    end
  end
end
