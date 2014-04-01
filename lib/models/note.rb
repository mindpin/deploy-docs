class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :title, :type => String
  field :content, :type => String
  field :last_editor_id, :type => String
  field :creator_id, :type => String

  def last_editor=(user)
    self.last_editor_id = user.user_id
  end

  def creator=(user)
    self.creator_id = user.user_id
  end

  def last_editor
    User.where(:user_id => last_editor_id).first
  end

  def creator
    User.where(:user_id => creator_id).first
  end

  before_create do |note|
    note.last_editor = note.creator
  end
end