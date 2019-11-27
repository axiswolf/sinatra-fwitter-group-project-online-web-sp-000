class UsersController < ApplicationController

  get '/users/:id' do
    @user = User.find_by_id([:user_id])
    erb :'/users/show'
  end

end
