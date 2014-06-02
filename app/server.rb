require 'sinatra'
require 'data_mapper'
require './lib/link'
require './lib/tag'
require './lib/user'
require_relative 'helpers/application'
require_relative 'data_mapper_setup'


enable :sessions
set :session_secret, 'super secret pass!!!'


get "/" do
  @links = Link.all	
  erb :index
end

post "/links" do
  url = params["url"]
  title = params["title"]
  tags = params["tags"].split(" ").map do |tag| 
    Tag.first_or_create(:text => tag)
  end
  Link.create(:url => url, :title => title, :tags => tags)
  redirect to('/')
end

get "/tags/:text" do
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end

get "/users/new" do
  erb :"users/new"
end

post "/users" do
  user = User.create(:email => params[:email],
              :password => params[:password],
              :password_confirmation => params[:password_confirmation])
  session[:user_id] = user.id
  redirect to("/")
end