class UsersController < ApplicationController
  
  def show
  	# REST url /users/1 converted to create a
  	# param[:id] = 1 which is a string
  	# but find is smart to convert to integer
  	@user = User.find(params[:id])
  end

  def new
  	# define user variable for the form 
  	# in the form view page
  	@user = User.new
  end

  def create 
  	# params is passed 
  	@user = User.new(params[:user])

  	if @user.save
      # sign in the user
      sign_in @user
  		#Handle a successful save.
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end
end
