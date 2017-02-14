module DNS
  class Factory
    CONSTANTS = %w(Lookup DKIM SPF)
    WRAPPER = self.to_s.deconstantize + '::'

    class << self
      def dns_inst(constant_name)
        raise DNS::Errors::ParamIsMissingError unless constant_name.present?

        klass = CONSTANTS.find { |i| i.downcase == constant_name.to_s }
        if klass.present?
          dns_const = WRAPPER + klass
          return Object.const_get(dns_const).new
        end

        raise DNS::Errors::UndefinedDNSConstantError
      end
    end
  end
end
