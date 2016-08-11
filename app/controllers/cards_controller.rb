# coding: utf-8
class CardsController < ApplicationController

  def create
    @card  = Card.new(card_params)
    token = @card.save

    if token
      @card = @card.to_permitted_json
      @card[:token] = token

      render_success_tokenization
    else
      render_fail_tokenization
    end
  end

  def charge
    card = Card.detokenize(params[:token])
    @payment = Payment.new(payment_params)

    if card
      if @payment.save
        Card.destroy(params[:token])
        render_payment_success
      else
        render_payment_errors
      end
    else
      render_invalid_token
    end

  end

  private
  def card_params
    params.require(:card).permit(:name, :number, :cvc)
  end

  def payment_params
    params.require(:payment).permit(:amount)
  end

  def render_success_tokenization
    render json: {
             success: true,
             card: @card
           }

  end

  def render_fail_tokenization
    render json: {
             success: false,
             errors: @card.errors
           }, status: 400

  end

  def render_payment_success
    render json: {
             success: true,
             payment: @payment.as_json
           }
  end

  def render_payment_errors
    render json: {
             success: false,
             errors: @payment.errors.messages
           }, status: 400
  end

  def render_invalid_token
    render json: {
             success: false,
             errors: { token:"token inválido" }
           }, status: 404
  end
end
