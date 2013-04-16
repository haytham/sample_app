# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
	attr_accessible :name, :email, :password, :password_confirmation
	has_secure_password  # this adds secure password
						 # storage and checking

	# since some databases adapters use case-sensitive
	# indices we make sure all emails are saved lower-case
	# that is they are all in the same case
	# {} => we are passing a code block
	before_save { |user| user.email =  email.downcase }
	before_save :create_remember_token

	validates :name, presence: true, length: { maximum: 50 }
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, 	presence: true, 
						format: { with: VALID_EMAIL_REGEX },
						uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }
	validates :password_confirmation, presence: true

	private 
		def create_remember_token
			# create token
			# Use self here else the assignment
			# would create a local variable called remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
