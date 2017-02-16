class DKIMService < BaseService
  class PublicKeyNotFoundError < StandardError
    def message
      I18n.t('errors.no_key')
    end
  end

  REGEX = %r{p=(\S*)}

  attr_reader :prefix, :domain, :result, :keys

  def initialize(domain, prefix)
    super()
    @domain, @prefix = domain, prefix
  end

  def call
    @result = dns_inst.search(domain, prefix)
    fetch_public_key && self
  rescue Resolv::ResolvError,
         DNS::Errors::BaseDNSError,
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
