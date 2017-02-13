require 'resolv'

module DNS
  class Base
    protected
    def dns_inst
      @dns_inst ||= Resolv::DNS.new
    end
  end
end
