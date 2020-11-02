require 'rails_helper'

RSpec.describe User, type: :model do
  # we could optionally have specify a context around related specs:
  # context "text describing the context" do
  #   ...
  # end"

  RSpec.configure do |config|
    config.before(:each) do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: "foobar", password_confirmation: "foobar")
    end
  end

  it "should be valid" do
    expect(@user).to be_valid
  end

  describe "when name is not provided" do
    it "validation should fail" do
      @user.name = "      "
      expect(@user).not_to be_valid
    end
  end

  describe "when email is not provided" do
    it "validation should fail" do
      @user.email = "     "
      expect(@user).not_to be_valid
    end
  end

  describe "when name is too long" do
    it "validation should fail" do
      @user.name = "a" * 51
      expect(@user).not_to be_valid
    end
  end

  describe "when email is too long" do
    it "validation should fail" do
      @user.email = "a" * 244 + "@example.com"
      expect(@user).not_to be_valid
    end
  end

  describe "when email is a valid address" do
    it "validation should succeed" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid, "#{valid_addresses.inspect} should be valid"
      end
    end
  end

  describe "when email is an invalid address" do
    it "validation should fail" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
      end
    end
  end

  describe "when user with duplicate email address" do
    it "validation should fail" do
      duplicate_user = @user.dup
      @user.save
      expect(duplicate_user).not_to be_valid
    end
  end

  describe "when a user entry is saved" do
    it "email addresses should be saved as lower-case" do
      mixed_case_email = "Foo@ExAMPle.CoM"
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "with a blank password" do
    it "should cause the validation to fail" do
      @user.password = @user.password_confirmation = " " * 6
      expect(@user).not_to be_valid
    end
  end

  describe "with a password with a length shorter than the minimum" do
    it "should cause the validation to fail" do
      @user.password = @user.password_confirmation = " " * 5
      expect(@user).not_to be_valid
    end
  end

end
