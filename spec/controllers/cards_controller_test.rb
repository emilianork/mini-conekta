require "rails_helper"

RSpec.describe CardsController, type: :controller do

  it "Sends a correct card" do
    card_request = { card:
                       { name: Faker::Name.name,
                         number: Faker::Number.number(16),
                         cvc: Faker::Number.number(3) }
                   }

    post :create, params: card_request

    response_hash = JSON.parse(response.body)
    expect(response_hash["success"]).to be(true)
    expect(response.status).to eq(200)
  end


  it "Sends a bad card" do
    card_request = { card:
                       { name: "",
                         number: Faker::Number.number(17),
                         cvc: Faker::Number.number(2) }
                   }

    post :create, params: card_request

    response_hash = JSON.parse(response.body)
    expect(response_hash["success"]).to be(false)
    expect(response.status).to eq(400)

    expect(response_hash["errors"]).to have_key("number")
    expect(response_hash["errors"]).to have_key("cvc")
    expect(response_hash["errors"]).to have_key("name")
  end

  it "creates a payment" do
    card = Card.new(name: Faker::Name.name, number: Faker::Number.number(16),
                    cvc: Faker::Number.number(3))

    token = card.tokenize
    request_params = { token: token, payment: { amount: Faker::Number.number(3).to_f } }

    post :charge, params: request_params

    response_hash = JSON.parse(response.body)
    expect(response.status).to eq(200)

    token_on_redis = $redis.get(token)
    expect(token_on_redis).to be(nil)
  end

  it "tries to create payment with bad token" do
    request_params = { token: Faker::Name.name,
                       payment: { amount: Faker::Number.number(3).to_f } }

    post :charge, params: request_params

    response_hash = JSON.parse(response.body)
    expect(response.status).to eq(404)
  end

  it "tries to create payment with bad amount" do
    card = Card.new(name: Faker::Name.name, number: Faker::Number.number(16),
                    cvc: Faker::Number.number(3))

    token = card.tokenize
    request_params = { token: token, payment: { amount: 0 } }

    post :charge, params: request_params

    response_hash = JSON.parse(response.body)
    expect(response.status).to eq(400)
  end
end
