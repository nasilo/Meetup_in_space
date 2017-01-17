require 'sinatra'
require_relative 'config/application'

set :bind, '0.0.0.0'  # bind to all interfaces

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @sorted_meetups = Meetup.order("lower(title)").all

  erb :'meetups/index'
end

post '/meetups/show/:id' do
  @not_signed_in = session[:user_id].nil?

  unless @not_signed_in
    @signup = Signup.new(user_id: session[:user_id], meetup_id: params[:id])
    if @signup.save
      meetup = Meetup.find(params[:id])
      flash[:notice] = "You have joined #{meetup.title}!"
    else
      flash[:notice] = "You have already joined this meetup!"
    end
  else
    flash[:notice] = "Sign in Foo!"
  end

  redirect "/meetups/show/#{params[:id]}"
end

get '/meetups/show/:id' do
  @meetup_show = Meetup.find(params[:id])
  signups = Signup.where('meetup_id = ?', params[:id])
  @attending = []
  signups.each do |signup|
    @attending << User.find(signup.user_id)
  end
  erb :'meetups/show'
end

post '/meetups/newevent' do
  @title = params["meetup_title"]
  @location = params["meetup_location"]
  @description = params["meetup_description"]
  # @error = [@title, @location, @description].include?("") || session[:user_id].nil?

  @meetup = Meetup.new(title: @title, location: @location, description: @description, user_id: session[:user_id])

  if @meetup.save
    flash[:notice] = "You have created #{@meetup.title}"
    redirect "/meetups/show/#{@meetup.id}"
  else
    @error = @meetup.errors.full_messages
    erb :'meetups/newevent'
  end

end

get '/meetups/newevent' do
  erb :'meetups/newevent'
end
