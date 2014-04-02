module AuthHelper
  def current_user=(user)
    if user.blank?
      session.delete :user_id
      return
    end
    session[:user_id] = user.user_id
  end

  def current_user
    if !session[:user_id].blank?
      return User.where(:user_id => session[:user_id]).first
    end
  end

  def login?
    !current_user.blank?
  end
end