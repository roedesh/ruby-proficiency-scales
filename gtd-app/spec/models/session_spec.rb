require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      expect(Session.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end

  describe 'creation' do
    let(:user) { users(:one) }

    it 'creates a valid session for a user' do
      session = Session.create!(user: user)
      expect(session).to be_valid
      expect(session.user).to eq(user)
    end

    it 'requires a user' do
      session = Session.new
      expect(session).not_to be_valid
      expect(session.errors[:user]).to be_present
    end
  end
end
