Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/api/users/', to: 'users#index', as: 'users'
  get '/api/proxy/', to: 'users#proxy', as: 'prox'
end
