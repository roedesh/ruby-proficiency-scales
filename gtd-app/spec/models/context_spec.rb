require 'rails_helper'

RSpec.describe Context, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      expect(Context.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'has many items' do
      expect(Context.reflect_on_association(:items).macro).to eq(:has_many)
    end
  end

  describe 'dependent nullify' do
    let(:context) { contexts(:one) }

    it 'nullifies associated items when context is destroyed' do
      item = Item.create!(
        user: context.user,
        context: context,
        item_type: 'action',
        status: 'inbox',
        energy_level: 'high'
      )
      context.destroy
      expect(item.reload.context_id).to be_nil
    end

    it 'does not destroy items when context is destroyed' do
      item = Item.create!(
        user: context.user,
        context: context,
        item_type: 'action',
        status: 'inbox',
        energy_level: 'high'
      )
      expect { context.destroy }.not_to change { Item.count }
    end
  end
end
