UfcfitAccountsApi::Application.routes.draw do
  resources :oauth_clients

  match "oauth/token", :controller => "oauth_authorize", :action => "token"

  namespace :api do
    namespace :v1 do
      match "/me", :controller => "users", :action => "me"
    end
  end

end
