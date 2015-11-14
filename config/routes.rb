Rails.application.routes.draw do
  ########################################################################
  # Stripe Routes
  ########################################################################
  mount StripeEvent::Engine => "/stripe/webhooks"

  ########################################################################
  # Admin Routes
  ########################################################################
  devise_for :admins,
             skip: [
              :sessions
             ],
             controllers: {
               sessions: 'admin/sessions'
             }
  constraints subdomain: "admin" do
    namespace :admin, path: "" do
      devise_scope :admin do
        # Sessions
        get   "/sign-in"  => "sessions#new",     as: :new_admin_session
        post  "/sign-in"  => "sessions#create",  as: :admin_session
        match "/sign-out" => "sessions#destroy", as: :destroy_admin_session, via: [:get, :delete]
        get   "/login"    => redirect("sign-in")
        unauthenticated :admin do
          root to: 'devise/sessions#new', as: :unauthenticated_admin_root
        end
        authenticated :admin do
          root to: 'application#index', as: :admin_dashboard
        end
      end

      # Application Resources
      resources :admins
      resources :donations
      resources :fundraisers, controller: :funds
      resources :metadata
      resources :users
    end
  end

  ########################################################################
  # User Routes
  ########################################################################

  devise_for :users,
  skip: [
    :sessions,
    :registrations
  ],
  controllers: {
    registrations: "registrations"
  }
  as :user do
    authenticated :user do
      root to: 'application#index', as: :user_dashboard
    end
    unauthenticated :user do
      root to: 'devise/sessions#new', as: :root
    end
    get "/sign-in" => redirect("login")
    get "/login" => "devise/sessions#new", as: :new_user_session
    post "/login" => "devise/sessions#create", as: :user_session
    get "/logout" => "devise/sessions#destroy", as: :destroy_user_session

    get "/sign-up/" => "registrations#new", as: :new_user_registration
    post "/sign-up/" => "registrations#create", as: :user_registration
    get "/setup" => "registrations#onboarding", as: :onboarding
    post "setup" => "registrations#onboarding", as: :save_onboarding

    get "/settings" => redirect("settings/profile")
    get "/settings/(:setting)" => "registrations#edit", as: :setting
    patch "/settings" => "registrations#update"
  end


  ########################################################################
  # Public Routes
  ########################################################################

  # Application Resources
  resources :donations
  resources :fundraisers, controller: :funds
  resources :metadata
  resources :users

end
