require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    user = build(:user)
    expect(user).to be_valid
  end

  context 'Associations' do
    it 'should have many projects' do
      assoc = User.reflect_on_association(:projects)
      expect(assoc.macro).to eq(:has_many)
    end
    it 'should have many project users' do
      assoc = User.reflect_on_association(:project_users)
      expect(assoc.macro).to eq(:has_many)
    end
    it 'should have many tickets' do
      assoc = User.reflect_on_association(:tickets)
      expect(assoc.macro).to eq(:has_many)
    end
    it 'should have many entries' do
      assoc = User.reflect_on_association(:entries)
      expect(assoc.macro).to eq(:has_many)
    end
  end

  context 'Validations' do
    before(:each) do
      @user = build(:user)
    end

    it 'accepts a valid user' do
      @user.password = '123456'
      @user.password_confirmation = '123456'
      expect(@user).to be_valid
    end
    it 'rejects a user with no username' do
      @user.username = nil
      expect(@user).not_to be_valid
      expect(@user.errors[:username]).to eq ["can't be blank"]
    end

    context 'passwords' do
      it 'rejects a user with no password' do
        @user.password = nil
        @user.password_confirmation = nil
        expect(@user).not_to be_valid
        expect(@user.errors[:password]).to eq ["can't be blank"]
      end
      it 'rejects a user with a missmatching password confimation' do
        @user.password = 'password'
        @user.password_confirmation = '123456'
        expect(@user).not_to be_valid
        expect(@user.errors[:password_confirmation]).to eq ["doesn't match Password"]
      end
    end

    context 'roles' do
      it 'default to "user"' do
        @user.save
        expect(@user.role).to eq('user')
      end
      # No endpoint is yet configured to provide this function and it can only be achieved through the server console at present
      it 'accepts 1 to have role "system_administrator"' do
        @user.role = 1
        @user.save
        expect(@user.role).to eq('system_administrator')
      end
      it 'rejects a user with role greater than 1' do
        expect { @user.role = 2 }.to raise_error(ArgumentError)
      end
      it 'rejects a user with role less than 0' do
        expect { @user.role = -1 }.to raise_error(ArgumentError)
      end
    end

    context 'email' do
      it 'rejects a user with no email' do
        @user.email = nil
        expect(@user).not_to be_valid
        expect(@user.errors[:email]).to eq ["can't be blank", 'is invalid']
      end
      it 'rejects a user with no email prefix' do
        @user.email = '@user.com'
        expect(@user).not_to be_valid
        expect(@user.errors[:email]).to eq ['is invalid']
      end
      it 'rejects a user with no email suffix' do
        @user.email = 'user'
        expect(@user).not_to be_valid
        expect(@user.errors[:email]).to eq ['is invalid']
      end
      it 'rejects a user with a duplicate email' do
        @user.save
        user1 = build(:user)
        expect(user1).not_to be_valid
        expect(user1.errors[:email]).to eq ['has already been taken']
      end
    end
  end
end
