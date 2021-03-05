require "bundler/setup"

require "yaml"

require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, "secret"
end

get "/" do
  "Hello World"
end