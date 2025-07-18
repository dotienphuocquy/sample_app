Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :products

    get "static_pages/home"
    get "static_pages/help"

    root "static_pages#home"
  end
end
