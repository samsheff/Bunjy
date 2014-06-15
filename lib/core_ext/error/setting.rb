class SettingError < BunjyError
  attr_reader :object

  def initialize(object)
    @object = object
  end

  class MissingParamsError < SettingError
    attr_reader :object

    def initialize(object)
      @object = object
    end
  end
end
