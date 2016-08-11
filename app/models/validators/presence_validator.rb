# coding: utf-8
class Validators::PresenceValidator < Validators::BaseValidator
  def validate(value)

    value = @model.send("#{@attribute}")

    if value.size < 1
      @model.errors[@attribute] = " es requerido"
    end
  end
end
