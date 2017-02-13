class LookupService < BaseService
  attr_reader :dns_inst, :address

  def initialize(address)
    @address = address
    super()
  end

  def call
    reverse = dns_inst.reverse(address).first
    forward = dns_inst.forward(r)
  rescue Resolv::ResolvError => e
    add_error(e)
  end

  private
  def dns_inst
    @nds_inst ||= DNS::Factory.dns_inst(:lookup)
  end
end
