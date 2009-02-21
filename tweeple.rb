require 'rubygems'
require 'sinatra'
require 'twitter'

get '/stylesheets/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :"stylesheets/stylesheet"
end

get '/' do
  haml :index
end

post '/show' do
  if params[:me].blank? || params[:password].blank?
    halt haml(:no_credentials)
  end

  user = Twitter::Base.new(params[:me], params[:password])
  if params[:tweeple].blank?
    haml :no_follower, :locals => {:follower => user.followers.first}
  else
    response = user.followers.any? {|follower| follower.name == params[:tweeple]} ? 'Yes' : 'No'
    haml :show, :locals => {:response => response}
  end
end

error Twitter::RateExceeded do
  "Twitter says you've been making too many requests. Wait for a bit and try again."
end

error Twitter::Unavailable do
  "Twitter is unavailable right now. Try again later."
end

error Twitter::CantConnect do
  "Can't connect to twitter. Did you give me the wrong credentials?"
end