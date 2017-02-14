module DNS
  module Errors
    class NoRecordsFoundError < StandardError; end
    class UndefinedDNSConstantError < StandardError; end
    class ParamIsMissingError < StandardError; end
  end
end
