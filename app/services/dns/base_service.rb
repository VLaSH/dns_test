module DNS
  class BaseService
    attr_accessor :errors

    def initialize
      @errors = []
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
