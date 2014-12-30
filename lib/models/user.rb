class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, :type => String
  field :name, :type => String
  field :avatar, :type => String
  field :user_id, :type => String

  def self.authenticate(email, password)
    R::USERS.each do |user_attr|
      if user_attr["email"] == email
        if !password.blank? && user_attr["password"] == password
          return User._create_or_update_by_info(user_attr)
        end
      end
    end
    return nil
  end

  def self._create_or_update_by_info(info)
    @email  = info["email"]
    @name   = info["name"]
    @avatar = info["avatar"]
    @user_id = info["id"]
    user = User.where(:user_id => @user_id).first
    if user.blank?
      user = User.create(
        :user_id => @user_id,
        :email   => @email,
        :name    => @name,
        :avatar  => @avatar
      )
    else
      user.update_attributes(
        :email   => @email,
        :name    => @name,
        :avatar  => @avatar
      )
    end
    user
  end

end