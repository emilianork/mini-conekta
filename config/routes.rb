Rails.application.routes.draw do

  post '/cards/tokens/', to: 'cards#create'
  put  '/cards/charge/', to: 'cards#charge'
  
end
