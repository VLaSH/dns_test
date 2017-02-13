module DNS
  class Factory
    CONSTANTS = %w(Lookup DKIM SPF)
    WRAPPER = self.to_s.deconstantize + '::'

    class << self
      def dns_inst(inst)
        klass = CONSTANTS.find { |i| i.downcase == inst.to_s }
        if klass.present?
          dns_const = WRAPPER + klass
          return Object.const_get(dns_const).new
        end
        binding.pry
        raise DNS::Errors::UndefinedDNSConstantError
      end
    end
  end
end
