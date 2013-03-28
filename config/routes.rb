UfcfitAccountsApi::Application.routes.draw do
  resources :oauth_clients

  match "oauth/token", :controller => "oauth_authorize", :action => "token"

  namespace :api, format: :json do
    namespace :v1 do
      match "/me", :controller => "users", :action => "me"
      resources :users
    end
  end
  match "*path", :to => "application#render_404"
end
