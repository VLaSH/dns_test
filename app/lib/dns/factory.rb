module DNS
  class Factory
    CONSTANTS = %w(Lookup DKIM SPF)
    WRAPPER = self.to_s.deconstantize << '::'

    class << self
      def dns_inst(inst)
        dns_const = WRAPPER + CONSTANTS.select { |i| i.downcase == inst.to_s }.first
        Object.const_get(dns_const).new
      end
    end
  end
end
