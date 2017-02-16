module DNS
  class SPFService < BaseService
    attr_reader :address, :domain, :result, :listed

    def initialize(address, domain)
      super()
      @domain = domain
      @result = []
      @valid = false
      @address = IPAddr.new(address)
    rescue IPAddr::InvalidAddressError => e
      add_error(e.message) && self
    end

    def call
      @result = dns_inst.search(domain)
      @valid = true and self
    rescue Errors::RecordIsInvalidError => e
      add_error(e.message) && self
    rescue Resolv::ResolvError,
           Errors::BaseDNSError => e
      add_error(e.message) && self
    end

    def listed?
      @listed = result.select { |r| IPAddr.new(r).include?(address) }
      listed.any?
    end

    def valid?
      @valid
    end

    private
    def dns_inst
      @dns_inst ||= DNS::Factory.dns_inst(:spf)
    end
  end
end
