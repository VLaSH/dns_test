module DNS
  module ServicesErrors
    class BaseServicesError < StandardError; end

    class PublicKeyNotFoundError < StandardError
      def message
        I18n.t('errors.no_key')
      end
    end
    class RecordsMismatchError < StandardError
      def message
        I18n.t('errors.mismatch')
      end
    end
  end
end
