require "rails_helper"

RSpec.describe Payment, type: :model do

  it "creates valid payment" do
    payment = Payment.new(amount: Faker::Number.number(3).to_f)

    expect(payment).to be_valid
  end

  it "tries to use an invalid amount" do
    payment = Payment.new(amount: Faker::Number.number(3).to_f * -1)
    expect(payment).to_not be_valid

    payment = Payment.new(amount: 0)
    expect(payment).to_not be_valid

    payment = Payment.new
    expect(payment).to_not be_valid
  end
end
