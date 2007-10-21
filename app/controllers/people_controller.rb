class PeopleController < ApplicationController
 
  def show
    @user = User.find_by_name(params[:name])
  end
end
