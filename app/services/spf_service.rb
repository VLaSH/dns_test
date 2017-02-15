class SPFService < BaseService
  attr_reader :address, :domain, :result, :listed

  def initialize(address, domain)
    @address = IPAddr.new(address)
    @domain = domain
    @result = []
    @valid = true
    super()
  end

  def call
    (@result = dns_inst.search(domain)) && self
  rescue Resolv::ResolvError,
         DNS::Errors::NoRecordsFoundError => e
    add_error(e.message) && self
  rescue DNS::Errors::RecordIsInvalidError => e
    @valid = false
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
