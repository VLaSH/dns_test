module DNS
  class SPF < Base
    IP4_REGEX = %r{ip4:([0-9.\/]+)}
    IP6_REGEX = %r{ip6:(\S*)}
    SPF_POLICY = 'v=spf1'

    attr_reader :records

    def search(domain)
      raise Errors::ParamIsMissingError unless domain.present?

      @raw_records = dns_inst.getresources(domain, Resolv::DNS::Resource::IN::TXT)

      raise Errors::NoRecordsFoundError, domain unless @raw_records.any?

      validate_records && parse_records!
      records
    end

    private
    attr_reader :raw_records

    def validate_records
      strings = raw_records.map(&:strings).flatten
      strings.each { |s| s.include?(SPF_POLICY) || (raise Errors::RecordIsInvalidError, self.class.name) }
    end

    def parse_records!
      strings = raw_records.map(&:strings).flatten
      @records = strings.map { |s| s.scan(IP4_REGEX) + s.scan(IP6_REGEX) }.flatten
    end
  end
end
