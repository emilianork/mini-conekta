# coding: utf-8
class Validators::OnlyNumbersValidator < Validators::BaseValidator
  def validate(boolean)

    value = @model.send("#{@attribute}")

    if value.nil? || value.to_i.to_s != value
      @model.errors[@attribute] = "solo debe contener digitos"
    end
  end
end
