module DNS
  class DKIM < Base
    POLICY = '_domainkey'

    def search(prefix, domain)
      selector = "#{prefix}.#{POLICY}.#{domain}"
      records = dns_inst.getresources(selector, Resolv::DNS::Resource::IN::TXT)
      raise Resolv::ResolvError unless records.any?
      records.map(&:strings).flatten!
    end
  end
end
