module UsersHelper

	# Returns the Gravatar (http://gravatar.com/) for the given user
	def gravatar_for(user)
		# get md5 digest which gravatar uses
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatars/#{gravatar_id}.png"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end	
end
