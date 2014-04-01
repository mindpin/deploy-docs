require 'spec_helper'

describe Note do
  before{
    @user = User.create(
      :user_id => 1, 
      :email => "fushang318@gmail.com",
      :name  => "fushang318",
      :avatar => "http://xxx"
    )
    @kaid = User.create(
      :user_id => 2, 
      :email => "kaid@gmail.com",
      :name  => "kaid",
      :avatar => "http://xxx"
    )
  }

  it "综合测试" do
    note = Note.create(
      :title => "title",
      :content => "content",
      :creator => @user
    )
    note.id.blank?.should == false
    note.title.should == "title"
    note.content.should == "content"
    note.creator.should == @user
    note.last_editor.should == note.creator
    note = Note.find(note.id)
    note.update_attributes(:content => "contentgai", :last_editor => @kaid)

    note = Note.find(note.id)
    note.content.should == "contentgai"
    note.last_editor.should == @kaid
    note.version.should == 2
    note.versions.first.version.should == 1
    note.versions.first.content.should == "content"
    note.versions.first.last_editor.should == @user
  end
end