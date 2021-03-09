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

def valid_name?(name)
  return false unless name.size > 0

  session[:groups].none? do |group|
    group[:name].downcase == name.downcase
  end
end

def valid_contact_info?(info)
  info.none? do |param|
    param.empty?
  end
end

get "/" do
  redirect "/groups"
end

get "/groups" do
  @groups = session[:groups]

  erb :home
end

get "/groups/:group/contacts" do
  group_name = params[:group]
  @current_group = session[:groups].select { |group| group_name == group[:name]}[0]
  @contacts = @current_group[:contacts]
  
  erb :contacts
end

get "/groups/:group/edit" do
  erb :edit_group
end

get "/groups/:group/contacts/:contact" do
  group_name = params[:group]
  contact_name = params[:contact]
  @current_group = session[:groups].select { |group| group_name == group[:name]}[0]
  @contact_info = @current_group[:contacts].select { |contact| contact[:name] == contact_name }[0]

  erb :contact
end

get "/groups/:group/contacts/:contact/edit" do
  group_name = params[:group]
  contact_name = params[:contact]
  @current_group = session[:groups].select { |group| group_name == group[:name]}[0]
  @contact_info = @current_group[:contacts].select { |contact| contact[:name] == contact_name }[0]

  erb :edit_contact
end

get "/groups/:group/new_contact" do
  erb :new_contact
end

get "/new_group" do
  erb :new_group
end

post "/groups/:group" do
  group_name = params[:group]
  @current_group = session[:groups].select { |group| group_name == group[:name]}[0]
  @contacts = @current_group[:contacts]

  name = params[:name].strip
  email = params[:email].strip
  cellphone = params[:cellphone].strip

  if valid_contact_info?([name, email, cellphone])
    @contacts << {
                    name: params[:name],
                    email: params[:email],
                    cellphone: params[:cellphone]
                  }
    
    session[:message] = "Contact has been created!"
    redirect "/groups/#{group_name}/contacts"
  else
    session[:message] = "Please fill in all fields."
    erb :new_contact
  end
end

post "/groups/:group/delete" do
  group_name = params[:group]
  @current_group = session[:groups].select { |group| group_name == group[:name]}[0]
  
  
  session[:groups].delete_if do |current_group|
    current_group[:name] == params[:group]
  end

  session[:message] = "Group has been deleted!"
  redirect "/groups"
end

post "/groups/:group/edit" do
  group_name = params[:group]
  @current_group = session[:groups].select { |group| group_name == group[:name]}[0]
  
  new_name = params[:group_name].strip
  
  if valid_name?(new_name)
    @current_group[:name] = new_name
    session[:message] = "Group name has been edited!"
    redirect "/groups"
  else
    session[:message] = "Invalid name! Please try again."
    erb :edit_group
  end
end

post "/groups/:group/contacts/:contact" do
  group_name = params[:group]
  @current_group = session[:groups].select { |group| group_name == group[:name]}[0]
  @contacts = @current_group[:contacts]
  @current_contact = @contacts.select { |contact| contact[:name] == params[:contact]}[0]
  
  name = params[:name].strip
  email = params[:email].strip
  cellphone = params[:cellphone].strip

  if valid_contact_info?([name, email, cellphone])
    @current_contact[:name] = name
    @current_contact[:email] = email
    @current_contact[:cellphone] = cellphone
    
    session[:message] = "Contact info has been edited!"
    redirect "/groups/#{group_name}/contacts"
  else
    session[:message] = "Please fill in all fields."
    erb :new_contact
  end
end

post '/groups/:group/contacts/:contact/delete' do
  group_name = params[:group]
  @current_group = session[:groups].select { |group| group_name == group[:name]}[0]
  @contacts = @current_group[:contacts]
  @current_contact = @contacts.select { |contact| contact[:name] == params[:contact]}[0]
  
  @contacts.delete_if do |current_contact|
    current_contact[:name] == params[:contact]
  end

  session[:message] = "Contact has been deleted!"
  redirect "/groups/#{params[:group]}/contacts"
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