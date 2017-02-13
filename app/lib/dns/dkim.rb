module DNS
  class DKIM < Base
    POLICY = '_domainkey'

    def search(prefix, domain)
      selector = "#{prefix}.#{POLICY}.#{domain}"
      records = dns_inst.getresources(selector, Resolv::DNS::Resource::IN::TXT)
      return records.map(&:strings).flatten if records.any?

      raise Errors::NoRecordsFoundError
    end
  end
end
