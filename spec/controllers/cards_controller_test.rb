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
end
