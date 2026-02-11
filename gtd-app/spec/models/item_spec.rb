require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      expect(Item.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'belongs to context (optional)' do
      expect(Item.reflect_on_association(:context).macro).to eq(:belongs_to)
      expect(Item.reflect_on_association(:context).options[:optional]).to eq(true)
    end

    it 'belongs to project (optional)' do
      expect(Item.reflect_on_association(:project).macro).to eq(:belongs_to)
      expect(Item.reflect_on_association(:project).options[:optional]).to eq(true)
    end

    it 'has many item_tags' do
      expect(Item.reflect_on_association(:item_tags).macro).to eq(:has_many)
    end

    it 'has many tags through item_tags' do
      association = Item.reflect_on_association(:tags)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:item_tags)
    end
  end

  describe 'validations' do
    describe 'item_type' do
      it 'accepts valid item types' do
        Item::ITEM_TYPES.each do |type|
          item = Item.new(
            user: users(:one),
            item_type: type,
            status: 'inbox',
            energy_level: 'high'
          )
          expect(item).to be_valid
        end
      end

      it 'rejects invalid item types' do
        item = Item.new(
          user: users(:one),
          item_type: 'invalid_type',
          status: 'inbox',
          energy_level: 'high'
        )
        expect(item).not_to be_valid
        expect(item.errors[:item_type]).to include('is not included in the list')
      end
    end

    describe 'status' do
      it 'accepts valid statuses' do
        Item::STATUSSES.each do |status|
          item = Item.new(
            user: users(:one),
            item_type: 'action',
            status: status,
            energy_level: 'high'
          )
          expect(item).to be_valid
        end
      end

      it 'rejects invalid statuses' do
        item = Item.new(
          user: users(:one),
          item_type: 'action',
          status: 'invalid_status',
          energy_level: 'high'
        )
        expect(item).not_to be_valid
        expect(item.errors[:status]).to include('is not included in the list')
      end
    end

    describe 'energy_level' do
      it 'accepts valid energy levels' do
        Item::ENERGY_LEVELS.each do |level|
          item = Item.new(
            user: users(:one),
            item_type: 'action',
            status: 'inbox',
            energy_level: level
          )
          expect(item).to be_valid
        end
      end

      it 'rejects invalid energy levels' do
        item = Item.new(
          user: users(:one),
          item_type: 'action',
          status: 'inbox',
          energy_level: 'invalid_level'
        )
        expect(item).not_to be_valid
        expect(item.errors[:energy_level]).to include('is not included in the list')
      end
    end
  end

  describe 'constants' do
    it 'defines ITEM_TYPES' do
      expect(Item::ITEM_TYPES).to eq(%w[action project reference someday_maybe])
    end

    it 'defines STATUSSES' do
      expect(Item::STATUSSES).to eq(%w[inbox next_action waiting_for completed archived])
    end

    it 'defines ENERGY_LEVELS' do
      expect(Item::ENERGY_LEVELS).to eq(%w[high medium low])
    end
  end

  describe 'dependent destroy' do
    it 'destroys associated item_tags when item is destroyed' do
      item = Item.create!(
        user: users(:one),
        item_type: 'action',
        status: 'inbox',
        energy_level: 'high'
      )
      ItemTag.create!(item: item, tag: tags(:one))
      expect { item.destroy }.to change { ItemTag.count }.by(-1)
    end
  end
end
