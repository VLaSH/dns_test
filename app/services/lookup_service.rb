class LookupService < BaseService
  class RecordsMismatchError < StandardError
    def message
      "Reverse dns lookup result doesn't match forward lookup result"
    end
  end

  attr_reader :dns_inst, :address, :result

  def initialize(address)
    @address = address
    @result = []
    super()
  end

  def call
    @result = dns_inst.reverse(address)
    forward = result.map { |r| dns_inst.forward(r) }.flatten
    check_mismatch(forward) && result
  rescue Resolv::ResolvError,
         DNS::Errors::NoRecordsFoundError,
         RecordsMismatchError => e
    add_error(e.message) && result
  end

  private
  def dns_inst
    @dns_inst ||= DNS::Factory.dns_inst(:lookup)
  end

  def check_mismatch(forward)
    forward.include?(address) || (raise RecordsMismatchError)
  end
end
