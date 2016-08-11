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

  def self.detokenize(token)
    encrypted_json = redis.get(token)

    return nil if encrypted_json.nil?

    self.get_from_json(encrypted_json)
  end

  def tokenize
    token = "token_#{SecureRandom.uuid}"

    # expired set to 10 minutes
    redis.set(token, self.to_encrypted_json, ex: 600, nx: true)

    token
  end

  def to_permitted_json
    { name: @name, last_digits: @number[-4, 4] }
  end

  def to_encrypted_json
    json = { name: @name, number: @number, cvc: @cvc }.to_json
    encrypted_json = Encryptor.encrypt(value: json)

    encrypted_json
  end

  def self.get_from_json(encrypted_json)
    json = JSON.parse(Encryptor.decrypt(encrypted_json), symbolize_names: true)

    card = Card.new(json)
    card
  end

  def ==(card)
    self.name == card.name and self.number == card.number and self.cvc == card.cvc
  end

  def save
    unless @errors.any?
      token = self.tokenize
      token
    end
  end
end
