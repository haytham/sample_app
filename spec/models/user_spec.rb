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

require 'spec_helper'

describe User do

	#before { @user = User.new(  name: "Example User", 
	#							email: "user@example.com",
	#							password: "foobar",
	#							password_confirmation: "foobar" ) }

	before do
		@user = User.new( name: "Example User", email: "user@example.com", 
					password: "foobar", password_confirmation: "foobar" )
	end

	subject { @user }

	it { should respond_to( :name ) }
	it { should respond_to( :email ) }
	it { should respond_to( :password_digest ) }
	it { should respond_to( :password ) }
	it { should respond_to( :password_confirmation ) }
	it { should respond_to( :remember_token ) }

	# authentication tests
	it { should respond_to( :authenticate ) }


	# object should be valid to begin with
	# this is what this check is for
	# be_valid used here because object responds to boolean
	# check .valid?
	it { should be_valid }

	# Presence tests
	describe "when name is not present" do
		before { @user.name= " " }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	# Length tests
	describe "when name too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password does not match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password confirmation is nill" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	# authenticate tests - match and mismatch

	describe "return value of authenticate method" do 
		before { @user.save } # save user in the database
		let (:found_user) { User.find_by_email( @user.email ) }

		describe "with valid password" do
			it { should == found_user.authenticate( @user.password ) }
		end

		describe "with invalid password" do
			let(:user_for_valid_password) {found_user.authenticate( "invalid" ) }

			it { should_not == user_for_valid_password }
			specify { user_for_valid_password.should be_false }
		end
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	#before do
	#	@user = User.new(name: "Example User", email: "user@example.com")
	#end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
						foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	# uniqueness test 
	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save

		end

		it { should_not be_valid }
	end

	describe "remember token" do
		before { @user.save }
		# its method applies teh test to given attribute
		# instead of the subject of the test
		its(:remember_token) { should_not be_blank }
		# equivalent to
		#it { @user.remember_token should_not be_blank }
	end
  #pending "add some examples to (or delete) #{__FILE__}"
end
