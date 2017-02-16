class LookupService < BaseService
  class RecordsMismatchError < StandardError
    def message
      I18n.t('errors.mismatch')
    end
  end

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
         DNS::Errors::BaseDNSError,
         RecordsMismatchError => e
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
