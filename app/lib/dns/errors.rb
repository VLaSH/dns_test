module DNS
  module Errors
    class BaseDNSError < StandardError; end
    class NoRecordsFoundError < BaseDNSError
      attr_reader :arg

      def initialize(arg)
        @arg = arg
      end

      def message
        I18n.t('errors.no_records', subject: arg)
      end
    end
    class RecordIsInvalidError < BaseDNSError
      attr_reader :arg

      def initialize(arg)
        @arg = arg
      end

      def message
        I18n.t('errors.invalid', record: arg)
      end
    end
    class UndefinedDNSConstantError < BaseDNSError; end
    class ParamIsMissingError < BaseDNSError; end
  end
end
