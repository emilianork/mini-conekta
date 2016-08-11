class CardsController < ApplicationController

  def create
    card  = Card.new(card_params)
    token = card.save

    if token
      card_response = card.to_permitted_json
      card_response[:token] = token
      render json: {
               success: true,
               card: card_response
             }
    else
      render json: {
               success: false,
               errors: card.errors
             }, status: 400
    end
  end

  private
  def card_params
    params.require(:card).permit(:name, :number, :cvc)
  end
end
