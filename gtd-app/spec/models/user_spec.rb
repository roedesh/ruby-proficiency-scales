require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has many sessions' do
      expect(User.reflect_on_association(:sessions).macro).to eq(:has_many)
    end

    it 'has many contexts' do
      expect(User.reflect_on_association(:contexts).macro).to eq(:has_many)
    end

    it 'has many items' do
      expect(User.reflect_on_association(:items).macro).to eq(:has_many)
    end

    it 'has many projects' do
      expect(User.reflect_on_association(:projects).macro).to eq(:has_many)
    end
  end

  describe 'has_secure_password' do
    it 'authenticates with correct password' do
      user = User.create!(
        email_address: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'returns false with incorrect password' do
      user = User.create!(
        email_address: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user.authenticate('wrong_password')).to be_falsey
    end

    it 'requires password confirmation to match' do
      user = User.new(
        email_address: 'test@example.com',
        password: 'password123',
        password_confirmation: 'different'
      )
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to be_present
    end
  end

  describe 'email normalization' do
    it 'normalizes email to lowercase' do
      user = User.create!(
        email_address: 'TEST@EXAMPLE.COM',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user.email_address).to eq('test@example.com')
    end

    it 'strips whitespace from email' do
      user = User.create!(
        email_address: '  test@example.com  ',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user.email_address).to eq('test@example.com')
    end

    it 'normalizes mixed case with whitespace' do
      user = User.create!(
        email_address: '  TeSt@ExAmPlE.com  ',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user.email_address).to eq('test@example.com')
    end
  end

  describe 'dependent destroy' do
    let(:user) { users(:one) }

    it 'destroys associated sessions when user is destroyed' do
      Session.create!(user: user)
      expect { user.destroy }.to change { Session.count }.by(-1)
    end

    it 'destroys associated contexts when user is destroyed' do
      initial_count = Context.where(user: user).count
      expect { user.destroy }.to change { Context.count }.by(-initial_count)
    end

    it 'destroys associated items when user is destroyed' do
      initial_count = Item.where(user: user).count
      expect { user.destroy }.to change { Item.count }.by(-initial_count)
    end

    it 'destroys associated projects when user is destroyed' do
      initial_count = Project.where(user: user).count
      expect { user.destroy }.to change { Project.count }.by(-initial_count)
    end
  end
end
