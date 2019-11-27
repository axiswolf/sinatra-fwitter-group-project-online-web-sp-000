require 'sinatra/base'
require 'rack-flash'
require_relative '../helpers/helpers'

class TweetsController < ApplicationController
  enable :sessions
  enable :method_override

 use Rack::Flash

  get '/tweets' do
      if Helpers.logged_in?(session)
          @user = Helpers.current_user(session)
          @tweets = Tweet.all
          @users = User.all
          erb :'/tweets/tweets'
      else
          redirect to "/login"
      end
  end

  get '/tweets/new' do
    if Helpers.logged_in?(session)
        @user = Helpers.current_user(session)
        @tweets = Tweet.all
        @users = User.all
        erb :'/tweets/new'
    else
        redirect to "/login"
    end
  end

  post '/tweets' do
    if !Helpers.logged_in?(session)
      redirect to "/login"
    else
      @user = Helpers.current_user(session)
      if params["content"] == ""
        redirect to "/tweets/new"
      else
        @tweet = Tweet.new(content: params["content"], user_id: current_user)
        @tweet.save
        @tweet.user = @user
        redirect to "/tweets"
      end
    end
  end

  get '/tweets/:id' do
    @user = Helpers.current_user(session)
    @tweet = Tweet.find(params[:id])
    erb :'/tweets/show'
  end

  delete '/tweets/:id' do
    if !Helpers.logged_in?(session)
      redirect to "/login"
    else
      @tweet = Tweet.find(params[:id])
      @user = Helpers.current_user(session)
      if @tweet.user_id == @user.id
        # if @tweet && @tweet.destroy
        #   redirect "/tweets"
        # else
        #   redirect "/tweets/#{tweet.id}"
        # end
        @tweet.destroy
        redirect "/tweets"
      end
    end
  end

  get '/tweets/:id/edit' do
    if @user = Helpers.current_user(session)
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/edit'
    else
      redirect '/login'
    end
  end
#    redirect to "/tweets/#{@tweets.id}"
  patch '/tweets/:id' do
      @tweet = Tweet.find(params[:id])
      @user = Helpers.current_user(session)
        if @tweet.user_id == @user.id
          if params["content"] != ""
              @tweet.content = params["content"]
              @tweet.save
              flash[:message] = "Successfully updated tweet."
              redirect to "/tweets/#{@tweet.id}/edit"
          else
              flash[:message] = "Your tweet cannot be empty."
              redirect to "/tweets/#{@tweet.id}/edit"
          end
        else
          flash[:message] = "You can only edit and delete your own tweets"
          redirect to "/tweets"
        end
    end
end
