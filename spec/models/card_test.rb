require "rails_helper"

RSpec.describe Card, type: :model do
  it "Valid card" do
    card = Card.new(name: Faker::Name.name, number: Faker::Number.number(16),
                    cvc: Faker::Number.number(3))

    expect(card.errors).to be_empty
  end

  it "has no valid name" do
    card = Card.new
    expect(card.errors).to have_key(:name)
  end

  it "has no valid number" do
    card = Card.new(number: Faker::Number.number(15))
    expect(card.errors).to have_key(:number)

    card = Card.new(number: Faker::Number.number(17))
    expect(card.errors).to have_key(:number)

    card = Card.new(number: Faker::Name.name + Faker::Number.number(16))
    expect(card.errors).to have_key(:number)

    card = Card.new
    expect(card.errors).to have_key(:number)
  end

  it "has no valid cvc" do
    card = Card.new(cvc: Faker::Number.number(2))
    expect(card.errors).to have_key(:cvc)

    card = Card.new(cvc: Faker::Name.name + Faker::Number.number(3))
    expect(card.errors).to have_key(:cvc)

    card = Card.new
    expect(card.errors).to have_key(:cvc)
  end

  it "encodes and decodes correctly" do
    card = Card.new(name: Faker::Name.name, number: Faker::Number.number(16),
                    cvc: Faker::Number.number(3))

    encrypted_json = card.to_json

    decrypted_card = Card.get_from_json(encrypted_json)

    expect(card).to eq(decrypted_card)
  end
end
