class Validators::BaseValidator
  def initialize(options={})
    @attribute = options[:attribute]
    @model    = options[:model]
  end
end
