class UsersController < ApplicationController

  get "/users/:id" do
    @user = User.find_by_id([:id])
    @tweets = Tweet.find(user_id: params["user_id"])
    erb :'/users/show'
  end

end
