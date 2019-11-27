class UsersController < ApplicationController

  get "/users/:id" do
    @user = User.find_by_id([:id])
    @tweets = Tweet.find(params[:user_id])
    erb :'/users/show'
  end

end
