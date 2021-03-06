require "bundler/setup"

require "yaml"

require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, "secret"
end

before do
  session[:groups] ||= []
end

def count_groups
  if session[:groups]
    group_count = session[:groups].size
    "You have created #{group_count} group(s)"
  else
    "Click 'Create Group' to create a new group"
  end
end

get "/" do
  redirect "/groups"
end

get "/groups" do
  @groups = session[:groups]

  erb :home
end

get "/new_group" do
  erb :new_group
end

def valid_name?(name)
  return false unless name.size > 0

  session[:groups].none? do |group|
    group[:name].downcase == name.downcase
  end
end

post "/groups" do
  new_group_name = params[:group].to_s.strip

  if valid_name?(new_group_name)
    session[:groups] << { name: new_group_name, contacts: [] }
    session[:message] = "New group has been created!"
    redirect "/groups"
  else
    session[:message] = "Invalid name! Please try again."
    erb :new_group
  end
end

helpers do
  def display_group_count
    if session[:groups].size > 0
      group_count = session[:groups].size
      "You have created #{group_count} group(s)."
    else
      "You have not created any groups (friends, family, work, etc)."
    end
  end
end