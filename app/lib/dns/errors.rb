module DNS
  module Errors
    class NoRecordsFoundError < StandardError
      attr_reader :arg

      def initialize(arg)
        @arg = arg
      end

      def message
        "Records for #{arg} not found"
      end
    end
    class RecordIsInvalidError < StandardError
      attr_reader :arg

      def initialize(arg)
        @arg = arg
      end

      def message
        "#{arg} Record is invalid"
      end
    end
    class UndefinedDNSConstantError < StandardError; end
    class ParamIsMissingError < StandardError; end
  end
end
