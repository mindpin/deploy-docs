require "bundler"
Bundler.setup(:default)
require "sinatra"
require "sinatra/reloader"
require 'sinatra/assetpack'
require "pry"
require 'haml'
require 'sass'
require 'coffee_script'
require 'yui/compressor'
require 'sinatra/json'
require 'mongoid'
Mongoid.load!("./config/mongoid.yml")

ENV_YAML = YAML.load_file("config/env.yml")
class R
  USER_EMAILS = ENV_YAML['user_emails']
  AUTH_URL    = ENV_YAML['auth_url']
end

require 'net/http'
require 'action_view'
require 'redcarpet'
require 'coderay'
require File.expand_path("../../lib/models/user",__FILE__)
require File.expand_path("../../lib/models/note",__FILE__)
require File.expand_path("../../lib/helpers/auth_helper",__FILE__)