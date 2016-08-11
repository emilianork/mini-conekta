# coding: utf-8
class Validators::LengthValidator < Validators::BaseValidator
  def validate(length)

    value = @model.send("#{@attribute}")

    if value.nil? || value.size != length
      @model.errors[@attribute] = "tamaño inválido"
    end
  end
end
