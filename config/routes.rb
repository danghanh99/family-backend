Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :events
      resources :check_lists
      resources :to_dos
      resources :users
      post 'google_login', to: 'sessions#google_login'
    end
  end
end
