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
              :sessions,
              :registrations
             ],
             controllers: {
               sessions: 'admin/sessions'
             }
  constraints subdomain: "admin" do
    namespace :admin, path: "" do
      devise_scope :admin do
        # Sessions
        get    "/sign-in"   =>  "sessions#new",      as: :new_admin_session
        post   "/sign-in"   =>  "sessions#create",   as: :new_session
        match  "/sign-out"  =>  "sessions#destroy",  as: :destroy_admin_session, via: [:get, :delete]
        get    "/login"     =>  redirect("sign-in")
        get    "/logout"    =>  redirect("sign-out")
        unauthenticated :admin do
          root to: 'sessions#new', as: :unauthenticated_admin_root
        end
        authenticated :admin do
          root to: 'admins#dashboard', as: :admin_dashboard
        end
      end

      # Application Resources
      resources :admins
      resources :donations do
        member do
          get :view_payment
        end
      end
      resources :fundraisers, controller: :funds
      resources :metadata
      resources :users, constraints: { username: /[0-9A-Za-z\.\-\_]+/ } do
        resources :funds, path: "/", only: [:show]
        member do
          get '/:selected_tab' => 'users#show', as: :selected_tab, constraints: { selected_tab: /(?!edit|signup)([a-zA-Z\-]+)/ }
        end
      end
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
    get   "/sign-in"   =>  redirect("login")
    get   "/sign-out"  =>  redirect("logout")
    get   "/login"     =>  "devise/sessions#new",      as: :new_user_session
    post  "/login"     =>  "devise/sessions#create",   as: :user_session
    get   "/logout"    =>  "devise/sessions#destroy",  as: :destroy_user_session
    get   "/sign-up/"  =>  "registrations#new",         as: :new_user_registration
    post  "/sign-up/"  =>  "registrations#create",      as: :user_registration

    get    "/setup/(:step)"  =>  "registrations#onboarding_step",  as: :onboarding_step
    patch  "setup/"          =>  "registrations#onboarding_progress",  as: :onboarding_progress
    patch  'update-stripe'   =>  'registrations#update_stripe', as: :update_stripe
    get    "/settings"             => redirect("settings/profile")
    get    "/settings/(:setting)"  => "registrations#edit",         as: :setting
    patch  "/settings"             => "registrations#update"
  end

  ########################################################################
  # Public Routes
  ########################################################################

  # Application Resources
  resources :donations
  resources :fundraisers, controller: :funds
  resources :metadata

  post '/verify/captcha' => 'donations#verify_captcha', as: :veryfiy_captcha

  resources :users, constraints: { username: /[0-9A-Za-z\.\-\_]+/ }, path: '/' do
    resources :funds, only: :show, path: '/'
  end

end
