class User
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
    User.new(info)
  end

  attr_reader :email, :name, :avatar
  def initialize(info)
    @email  = info["email"]
    @name   = info["name"]
    @avatar = info["avatar"]
  end
end