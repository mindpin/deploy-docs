class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, :type => String
  field :name, :type => String
  field :avatar, :type => String
  field :user_id, :type => String

  def self.authenticate(email, password)
    return if !R::USER_EMAILS.include?(email)

    params = {
      "user[login]"    => email,
      "user[password]" => password
    }
    uri = URI.parse(R::AUTH_URL)
    res = Net::HTTP.post_form(uri, params)
    return if res.code != "200"
    info = JSON.parse(res.body)
    User._create_or_update_by_info(info)
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