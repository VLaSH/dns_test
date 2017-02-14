module DNS
  class SPF < Base
    IP4_REGEX = %r{ip4:([0-9.\/]+)}

    attr_reader :records, :ranges

    def search(domain)
      raise Errors::ParamIsMissingError unless domain.present?

      @raw_records = dns_inst.getresources(domain, Resolv::DNS::Resource::IN::TXT)
      parse_records!
      return update_ranges! && records if records.any?

      raise Errors::NoRecordsFoundError
    end

    private
    attr_reader :raw_records

    def parse_records!
      strings = raw_records.map(&:strings).flatten
      @records = strings.map { |s| s.scan(IP4_REGEX) }.flatten
    end

    def update_ranges!
      @ranges = []
      @records.map { |record| @ranges.push(IPAddr.new(record).to_range) }
    end
  end
end
