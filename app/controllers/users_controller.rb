class UsersController < ApplicationController

  get '/users/:id' do
    #@user = User.find_by_id([:user_id])
    tweets = Tweets.find(user_id: params[:id])
    erb :'/users/show'
  end

end
