class SPFService < BaseService
  attr_reader :address, :domain, :result

  def initialize(address, domain)
    @address = IPAddr.new(address)
    @domain = domain
    @result = []
    @valid = true
    super()
  end

  def call
    @result = dns_inst.search(domain)
  rescue Resolv::ResolvError,
         DNS::Errors::NoRecordsFoundError => e
    add_error(e.message) && result
  rescue DNS::Errors::RecordIsInvalidError => e
    @valid = false
    add_error(e.message) && result
  end

  def listed?
    result.select { |r| IPAddr.new(r).include?(address) }
  end

  def valid?
    @valid
  end

  private
  def dns_inst
    @dns_inst ||= DNS::Factory.dns_inst(:spf)
  end
end
