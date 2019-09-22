Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :top_urls, only: [:index]
      resource :links, only: [:create, :show]
    end
  end
end
