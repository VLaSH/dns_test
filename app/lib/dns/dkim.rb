module DNS
  class DKIM < Base
    POLICY = '_domainkey'

    def search(prefix, domain)
      raise Errors::ParamIsMissingError unless (prefix.present? && domain.present?)

      selector = "#{prefix}.#{POLICY}.#{domain}"
      records = dns_inst.getresources(selector, Resolv::DNS::Resource::IN::TXT)
      return records.map(&:strings).flatten if records.any?

      raise Errors::NoRecordsFoundError, domain
    end
  end
end
