class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def stripe_connect
    if user_signed_in
    request.env["omniauth.auth"]
    else
      redirect_to new_user_session_path, alert: "You must be signed in to link your Stripe Account."
    end
    # Delete the code inside of this method and write your own.
    # The code below is to show you where to access the data.
  end
end
