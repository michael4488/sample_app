require 'spec_helper'

describe User do
  before {@user = User.new(name: "Michael", email: "michael@simplee.com", 
                           password: "foofoo", password_confirmation: "foofoo")}
  subject {@user}

  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it { should respond_to(:authenticate) }
  it {should be_valid}

# name
  describe "when name is empty" do
    before {@user.name = "   "}

    it {should_not be_valid}
  end

  describe "when name is too long" do
    before {@user.name = "a" * 51}

    it {should_not be_valid}
  end

# email
  describe "when email is empty" do
    before {@user.email = "   "}

    it {should_not be_valid}
  end

  describe "when email is valid" do 
    it "should be valid" do
      addresses = %w[user@simplee.com A_BB@gmail.net A@G.com]
      addresses.each do |a|
        @user.email = a
        @user.should be_valid
      end
    end
  end

  describe "when email is invalid" do 
    it "should not be valid" do
      addresses = %w[usersimplee.com A_BB@gmail,net A@Gmail something michael@simplee.]
      addresses.each do |a|
        @user.email = a
        @user.should_not be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before {
      dup_user = @user.dup
      dup_user.email = dup_user.email.upcase
      dup_user.save
    }

    it {should_not be_valid}
  end

  # password
  describe "when password is empty" do
    before {@user.password = @user.password_confirmation = "   "}

    it {should_not be_valid}
  end

  describe "when password confiramtion isnt match" do
    before {@user.password_confirmation = "a"}

    it {should_not be_valid}
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email("michael@simplee.com") }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
end
