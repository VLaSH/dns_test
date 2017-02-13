module DNS
  class SPF < Base
    attr_reader :records

    def search(domain)
      @records = dns_inst.getresources(domain, Resolv::DNS::Resource::IN::TXT)
      @records.map!(&:strings).flatten!
    end
  end
end
