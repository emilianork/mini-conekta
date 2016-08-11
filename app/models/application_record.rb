class ApplicationRecord
  include Redis::Objects

  def validates(attribute, validators={})
    validators.each do |key, value|
      klass_name = "validators/#{key.to_s}_validator".classify
      klass = klass_name.constantize

      klass.new(model: self, attribute: attribute).validate(value)
    end
  end

end
