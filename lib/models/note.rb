class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :title, :type => String
  field :content, :type => String
  field :last_editor, :type => String
  field :creator, :type => String

  before_create do |note|
    note.last_editor = note.creator
  end
end