class DKIMService < BaseService
  class PublicKeyNotFoundError < StandardError
    def message
      'Public key was not found'
    end
  end

  REGEX = %r{p=(\S*)}

  attr_reader :prefix, :domain, :result, :keys

  def initialize(prefix, domain)
    @prefix, @domain = prefix, domain
    super()
  end

  def call
    @result = dns_inst.search(prefix, domain)
    fetch_public_key && self
  rescue Resolv::ResolvError,
         DNS::Errors::NoRecordsFoundError,
         PublicKeyNotFoundError => e
    add_error(e.message) && self
  end

  private
  def dns_inst
    @dns_inst ||= DNS::Factory.dns_inst(:dkim)
  end

  def fetch_public_key
    @keys = result.map { |r| r.scan(REGEX) }.flatten
    keys.any? || (raise PublicKeyNotFoundError)
  end
end
