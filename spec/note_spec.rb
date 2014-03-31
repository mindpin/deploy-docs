require 'spec_helper'

describe Note do
  it "综合测试" do
    note = Note.create(
      :title => "title",
      :content => "content",
      :creator => "fushang318"
    )
    note.id.blank?.should == false
    note.title.should == "title"
    note.content.should == "content"
    note.creator.should == "fushang318"
    note.last_editor.should == note.creator
    note.update_attributes(:content => "contentgai", :last_editor => "kaid")

    note = Note.find(note.id)
    note.content.should == "contentgai"
    note.last_editor == "kaid"
    note.version.should == 2
    note.versions.first.version == 1
    note.versions.first.content == "content"
    note.versions.first.last_editor == "fushang318"
  end
end