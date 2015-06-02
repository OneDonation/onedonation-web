Rails.application.routes.draw do

  get 'users/index'

  get 'users/show'

  get 'users/edit'

  get 'users/update'

  get 'users/destroy'

  ########################
  # Stripe Routes
  ########################
  mount StripeEvent::Engine => "/stripe/webhooks"

  ########################
  # Admin Routes
  ########################
  devise_for :admins, skip: [:sessions]
  constraints subdomain: "admin" do
    as :admin do
      unauthenticated :admin do
        root to: 'devise/sessions#new', as: :root_admin_session
      end
      authenticated :admin do
        root to: 'application#index', as: :admin_dashboard
      end
      post "/sign-in" => "devise/sessions#create", as: :admin_session
      get "/sign-in" => "devise/sessions#new", as: :new_admin_session
      match "/sign-out" => "devise/sessions#destroy", as: :destroy_admin_session, via: [:get, :delete]
      get "/login" => redirect("sign-in")
    end
  end

  ########################
  # User Routes
  ########################
  devise_for :users,
  skip: [
    :sessions,
    :registrations
  ],
  controllers: {
    registrations: "registrations",
    omniauth_callbacks: "omniauth_callbacks",
    confirmations: "confirmations"
  }
  as :user do
    authenticated :user do
      root to: 'application#index', as: :user_dashboard
    end
    unauthenticated :user do
      root to: 'devise/sessions#new', as: :root
    end
    # authenticated :admin do
    #   redirect_to
    # end
    get "/login" => "devise/sessions#new", as: :new_user_session
    post "/login" => "devise/sessions#create", as: :user_session
    get "/logout" => "devise/sessions#destroy", as: :destroy_user_session

    get "/get-started/" => "registrations#new", as: :new_user_registration
    post "/get-started/" => "registrations#create", as: :user_registration
    get "/setup" => "registrations#setup_stripe_account", as: :setup_stripe_account
    post "setup" => "registrations#update_stripe_account", as: :update_stripe_account
    get "/congrats" => "confirmations#congrats", as: :registration_complete
    patch "/confirm" => "confirmations#confirm"
    get "account/confirmation" => "confirmations#show", as: :user_confirm

    get "/settings" => redirect("settings/profile")
    get "/settings/(:setting)" => "registrations#edit", as: :setting
    patch "/settings" => "registrations#update"
  end


  get "donors/index"

  resources :accounts
  resources :donations
  resources :donors, only: :index
  resources :fundraisers, controller: :funds
  resources :metadata
  resources :users



  resources :accounts do
    resources :donors, only: :index
    resources :donations
    resources :fundraisers, controller: :funds
  end

end
