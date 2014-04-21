require "./lib/app"
require "mde-4ye"

DeployDocsApp.register MDE4ye
MDE4ye.mount!(self)

run DeployDocsApp.new
