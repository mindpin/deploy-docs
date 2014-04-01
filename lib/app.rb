require File.expand_path("../../config/env",__FILE__)

class DeployDocsApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  set :views, ["templates"]
  set :root, File.expand_path("../../", __FILE__)
  register Sinatra::AssetPack
  enable :sessions
  helpers AuthHelper

  assets {
    serve '/js', :from => 'assets/javascripts'
    serve '/css', :from => 'assets/stylesheets'

    js :application, "/js/application.js", [
      '/js/jquery-1.11.0.min.js',
      '/js/**/*.js'
    ]

    css :application, "/css/application.css", [
      '/css/**/*.css'
    ]

    css_compression :yui
    js_compression  :uglify
  }

  before do
    return if !request.path_info.match(/^.*js$/).blank?
    return if !request.path_info.match(/^.*css$/).blank?
    if !request.path_info.match(/^\/notes.*$/).blank?
      redirect "/" if !login?
    end
  end

  get "/" do
    if !login?
      return haml :login
    end
    haml :index
  end

  post "/login" do
    email = params["email"]
    password = params["password"]
    return haml :login if email.blank? || password.blank?

    user = User.authenticate(email, password)
    return haml :login if user.blank?
    self.current_user = user
    redirect "/"
  end

  get "/notes/new" do
    haml :notes_new
  end

  post "/notes" do
    title = params["title"]
    content = params["content"]
    return haml :notes_new if title.blank? || content.blank?
    note = Note.create(:title => title, :content => content, :creator => current_user)
    return haml :notes_new if note.id.blank?
    redirect "/notes/#{note.id}"
  end

  get "/notes/:id" do
    @note = Note.find(params[:id])
    haml :notes_show
  end

  get "/notes/:id/edit" do
    @note = Note.find(params[:id])
    haml :notes_edit
  end

  post "/notes/:id" do
    @note = Note.find(params[:id])
    title = params["title"]
    content = params["content"]
    return haml :notes_edit if title.blank? || content.blank?
    @note.update_attributes(
      :title => title,
      :content => content,
      :last_editor => self.current_user
    )
    redirect "/notes/#{@note.id}"
  end

  get "/logout" do
    self.current_user = nil
    redirect "/"
  end
end