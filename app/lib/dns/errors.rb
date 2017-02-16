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
    class UndefinedDNSConstantError < BaseDNSError
      def message
        I18n.t('errors.undefined_dns_constant')
      end
    end
    class ParamIsMissingError < BaseDNSError
      def message
        I18n.t('errors.missing_param')
      end
    end
  end
end
