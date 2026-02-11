require 'rails_helper'

RSpec.describe ItemTag, type: :model do
  describe 'associations' do
    it 'belongs to item' do
      expect(ItemTag.reflect_on_association(:item).macro).to eq(:belongs_to)
    end

    it 'belongs to tag' do
      expect(ItemTag.reflect_on_association(:tag).macro).to eq(:belongs_to)
    end
  end

  describe 'join table behavior' do
    it 'creates a valid association between item and tag' do
      item = items(:one)
      tag = tags(:one)
      item_tag = ItemTag.create!(item: item, tag: tag)
      expect(item_tag).to be_valid
      expect(item_tag.item).to eq(item)
      expect(item_tag.tag).to eq(tag)
    end

    it 'allows item to have multiple tags' do
      item = Item.create!(
        user: users(:one),
        item_type: 'action',
        status: 'inbox',
        energy_level: 'high'
      )
      tag1 = Tag.create!(name: 'Tag 1')
      tag2 = Tag.create!(name: 'Tag 2')
      ItemTag.create!(item: item, tag: tag1)
      ItemTag.create!(item: item, tag: tag2)

      expect(item.tags.count).to eq(2)
      expect(item.tags).to include(tag1, tag2)
    end

    it 'allows tag to be associated with multiple items' do
      tag = Tag.create!(name: 'Shared Tag')
      item1 = items(:one)
      item2 = items(:two)
      ItemTag.create!(item: item1, tag: tag)
      ItemTag.create!(item: item2, tag: tag)

      expect(tag.items.count).to eq(2)
      expect(tag.items).to include(item1, item2)
    end
  end
end
