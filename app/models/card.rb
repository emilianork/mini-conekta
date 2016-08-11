class Card < ApplicationRecord

  attr_accessor :name, :cvc, :number, :errors
  
  def initialize(attributes={})

    @name   = attributes[:name].to_s || ""
    @cvc    = attributes[:cvc].to_s || ""
    @number = attributes[:number].to_s || ""
    @errors = {}
    
    validates :name, presence: true
    validates :number, length: 16, only_numbers: true
    validates :cvc, length: 3, only_numbers: true
  end
  
end
