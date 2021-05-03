Rails.application.routes.draw do
  resources :items do
    member do
      patch :move
      put :check
      put :uncheck
    end
  end

  root to: "items#index"
end
