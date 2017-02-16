module DNS
  class LookupService < BaseService
    attr_reader :dns_inst, :address, :result

    def initialize(address)
      super()
      @address = address
      @result = []
    end

    def call
      @result = dns_inst.reverse(address)
      forward = result.map { |r| dns_inst.forward(r) }.flatten
      check_mismatch(forward) && self
    rescue Resolv::ResolvError,
           Errors::BaseDNSError,
           ServicesErrors::RecordsMismatchError => e
      add_error(e.message) && self
    end

    private
    def dns_inst
      @dns_inst ||= DNS::Factory.dns_inst(:lookup)
    end

    def check_mismatch(forward)
      forward.include?(address) || (raise RecordsMismatchError)
    end
  end
end
