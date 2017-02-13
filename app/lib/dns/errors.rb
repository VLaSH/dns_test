module DNS
  module Errors
    class NoRecordsFoundError < StandardError; end
    class UndefinedDNSConstantError < StandardError; end
  end
end
