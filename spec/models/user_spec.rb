require 'rails_helper'

RSpec.describe User, type: :model do
  context "Validations" do
    it 'accepts a valid user' do
      user = User.new(email: "test@user.com", username: "test user", password_digest: User.digest("testuserpassword"), role: 0)
      expect(user).to be_valid
    end
    it 'rejects a user with no username' do
      user = User.new(email: "test@user.com", username: "", password_digest: User.digest("testuserpassword"), role: 0)
      expect(user).not_to be_valid
      expect(user.errors[:username]).to eq ["can't be blank"]
    end
    it 'rejects a user with no password' do
      user = User.new(email: "test@user.com", username: "test user", password_digest: "", role: 0)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to eq ["can't be blank"]
    end
    
    context "roles" do
      it 'default to "user"' do
        user = User.new(email: "test@user.com", username: "test user", password_digest: User.digest("testuserpassword"))
        user.save
        expect(user.role).to eq("user")
      end
      # No endpoint is yet configured to provide this function and it can only be achieved through the server console at present
      it 'accepts 1 to have role "system_administrator"' do
        user = User.new(email: "test@user.com", username: "test user", password_digest: User.digest("testuserpassword"), role: 1)
        user.save
        expect(user.role).to eq("system_administrator")
      end
      it 'rejects a user with role greater than 1' do
        user = User.new(email: "test@user.com", username: "test user", password_digest: User.digest("testuserpassword"))
        expect { user.role = 2 }.to raise_error(ArgumentError)
      end
      it 'rejects a user with role less than 0' do
        user = User.new(email: "test@user.com", username: "test user", password_digest: User.digest("testuserpassword"))
        expect { user.role = -1 }.to raise_error(ArgumentError)
      end
    end

    context 'email' do
      it 'rejects a user with no email prefix' do
        user = User.new(email: "@user.com", username: "test user", password_digest: User.digest("testuserpassword"), role: 0)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to eq ['is invalid']
      end
      it 'rejects a user with no email suffix' do
        user = User.new(email: "test@", username: "test user", password_digest: User.digest("testuserpassword"), role: 0)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to eq ['is invalid']
      end
      it 'rejects a user with a duplicate email' do
        User.create!(email: "test@user.com", username: "test user", password_digest: User.digest("testuserpassword"), role: 0)
        user = User.new(email: "test@user.com", username: "test user", password_digest: User.digest("testuserpassword"), role: 0)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to eq ['has already been taken']
      end
    end
  end
end
