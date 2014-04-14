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

  def markdown_content
    options = {   
        :autolink => true, 
        :space_after_headers => true,
        :fenced_code_blocks => true,
        :no_intra_emphasis => true,
        :hard_wrap => false,
        :strikethrough =>true
      }
    markdown = Redcarpet::Markdown.new(HTMLwithCodeRay,options)
    markdown.render(content).html_safe
  end

  before_create do |note|
    note.last_editor = note.creator
  end

  class HTMLwithCodeRay < Redcarpet::Render::HTML
    def block_code(code, language)
      return code if code.blank?
      return _normal_block(code)  if language.blank?
      CodeRay.scan(code, language).div(:tab_width=>2, :css => :class)
    end

    def _normal_block(code)
      # 去掉结尾的回车
      code = code.gsub(/(\r?\n)+\z/,"")
      %`<div class="CodeRay"><br/><div class="code"><pre>#{code}</pre></div><br/></div>`
    end
  end
end