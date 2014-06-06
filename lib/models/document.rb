module DocumentsStore
  class Document
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
  end
end
