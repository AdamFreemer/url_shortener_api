Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :top_urls, only: [:index]
      resources :links, only: [:create]
      resources :busy, only: [:index]
    end
  end
  get '/:id', to: 'api/v1/links#show'
end
