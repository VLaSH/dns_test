module DNS
  class Lookup < Base
    def forward(domain)
      addresses = dns_inst.getaddresses(domain)
      return addresses.map(&:to_s).sort if addresses.any?

      raise Errors::NoRecordsFoundError
    end

    def reverse(address)
      names = dns_inst.getnames(address)
      return names.map(&:to_s).sort if names.any?

      raise Errors::NoRecordsFoundError
    end
  end
end
