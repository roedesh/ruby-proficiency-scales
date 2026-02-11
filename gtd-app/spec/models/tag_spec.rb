require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'associations' do
    it 'has many item_tags' do
      expect(Tag.reflect_on_association(:item_tags).macro).to eq(:has_many)
    end

    it 'has many items through item_tags' do
      association = Tag.reflect_on_association(:items)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:item_tags)
    end
  end

  describe 'dependent destroy' do
    it 'destroys associated item_tags when tag is destroyed' do
      tag = Tag.create!(name: 'Test Tag')
      ItemTag.create!(item: items(:one), tag: tag)
      expect { tag.destroy }.to change { ItemTag.count }.by(-1)
    end

    it 'does not destroy associated items when tag is destroyed' do
      tag = Tag.create!(name: 'Test Tag')
      item = items(:one)
      ItemTag.create!(item: item, tag: tag)
      expect { tag.destroy }.not_to change { Item.count }
    end
  end
end
