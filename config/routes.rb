Rails.application.routes.draw do
  resources :pictures do
    collection do
      get :check_status
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pictures#index'
end
