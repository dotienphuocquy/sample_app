Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :products

    get "/home", to: "static_pages#home"
    get "/help", to: "static_pages#help"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users, only: %i(show)

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    root "static_pages#home"
  end
end
