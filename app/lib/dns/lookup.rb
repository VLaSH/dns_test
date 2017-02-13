module DNS
  class Lookup < Base
    def forward(domain)
      addresses = dns_inst.getaddresses(domain)
      raise Resolv::ResolvError unless addresses.any?
      addresses.map(&:to_s).sort
    end

    def reverse(address)
      names = dns_inst.getnames(address)
      raise Resolv::ResolvError unless names.any?
      names.map(&:to_s).sort
    end
  end
end
