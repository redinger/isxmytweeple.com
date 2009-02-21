require 'rubygems'
require 'sinatra'
require 'twitter'

get '/' do
  haml :index
end

post '/show' do
  response = Twitter::Base.new(params[:me], params[:password]).followers.any? {|follower| follower.name == params[:tweeple]} ? 'Yes' : 'No'
  haml :show, :locals => {:response => response}
end