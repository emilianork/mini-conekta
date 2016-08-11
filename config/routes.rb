Rails.application.routes.draw do

  post '/cards/tokens/', to: 'cards#create'
  
end
