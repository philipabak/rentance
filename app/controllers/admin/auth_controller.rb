class Admin::AuthController < Admin::BaseController
  layout 'admin/auth'

  def login
    if request.post?
      administrator = Administrator.authenticate(params[:name], params[:password])
      if administrator
        reset_session     # session fixation countermeasures
        session[:administrator_id] = administrator.id
        redirect_to admin_root_url
      else
        flash.now[:alert] = "Invalid user/password combination"
      end
    else
      if session[:administrator_id]
        redirect_to admin_root_url
      end
    end
  end

  def logout
    reset_session
    redirect_to admin_login_url
  end
end
