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

  describe 'validations' do
    it 'requires name' do
      context = Context.new(user: users(:one))
      expect(context).not_to be_valid
      expect(context.errors[:name]).to include("can't be blank")
    end

    it 'is valid with name' do
      context = Context.new(user: users(:one), name: 'Home')
      expect(context).to be_valid
    end
  end

  describe 'dependent nullify' do
    let(:context) { contexts(:one) }

    it 'nullifies associated items when context is destroyed' do
      item = Item.create!(
        user: context.user,
        context: context,
        title: 'Test item',
        item_type: 'action',
        status: 'inbox',
        energy_level: 'high'
      )
      context.destroy
      expect(item.reload.context_id).to be_nil
    end

    it 'does not destroy items when context is destroyed' do
      Item.create!(
        user: context.user,
        context: context,
        title: 'Test item',
        item_type: 'action',
        status: 'inbox',
        energy_level: 'high'
      )
      expect { context.destroy }.not_to change { Item.count }
    end
  end
end
