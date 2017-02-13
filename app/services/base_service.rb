class BaseService
  attr_accessor :errors

  def initialize
    @errors = []
  end

  protected
  def add_error(e)
    if e.is_a?(Array)
      @errors = e
    else
      @errors << e
    end
  end
end
