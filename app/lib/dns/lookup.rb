module DNS
  class Lookup < Base
    def forward(domain)
      raise Errors::ParamIsMissingError unless domain.present?

      addresses = dns_inst.getaddresses(domain)
      return addresses.map(&:to_s).sort if addresses.any?

      raise Errors::NoRecordsFoundError, domain
    end

    def reverse(address)
      raise Errors::ParamIsMissingError unless address.present?

      names = dns_inst.getnames(address)
      return names.map(&:to_s).sort if names.any?

      raise Errors::NoRecordsFoundError, address
    end
  end
end
