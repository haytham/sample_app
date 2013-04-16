module SessionsHelper
	# automatically included in session view
	# but need to include in the controller
	def sign_in(user)
		# cookies is actually a hash of two value hashes
		# permanent was added as shortcut to
		# cookies[:remember_token] = { value: user.remember_token,
		# 							   expires: 20.years.from_now.utc }
		cookies.permanent[:remember_token] = user.remember_token
		# This line makes user available in both controllers and views
		# which allows constructions such as
		# <%= current_user.name %>
		# and
		# redirect_to current_user
		# self needed else Ruby will create a local variable
		# called current_user
		self.current_user = user
	end

	def current_user=(user)
		@current_user=user
	end

	# This is useless and will cause user to 
	# disappear as it make current_user a local variable
	# as we have replicated the functionality of
	# attr_accessor
	#def current_user
	#	@current_user
	#end

	# alternative
	# find current_user in database by remember_token
	# only if it is not set already - ||= operator says 
	# find unless already set
	# useful if current_user called more than once during a request
	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	# is the user signed in?
	def signed_in?
		!current_user.nil?
	end


	def sign_out
		self.current_user = nil
		cookies.delete( :remember_token )
	end
end
