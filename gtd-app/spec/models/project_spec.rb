require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      expect(Project.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'has many items' do
      expect(Project.reflect_on_association(:items).macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    describe 'status' do
      it 'accepts valid statuses' do
        Project::STATUSSES.each do |status|
          project = Project.new(
            user: users(:one),
            status: status
          )
          expect(project).to be_valid
        end
      end

      it 'rejects invalid statuses' do
        project = Project.new(
          user: users(:one),
          status: 'invalid_status'
        )
        expect(project).not_to be_valid
        expect(project.errors[:status]).to include('is not included in the list')
      end
    end
  end

  describe 'constants' do
    it 'defines STATUSSES' do
      expect(Project::STATUSSES).to eq(%w[active on_hold completed])
    end
  end

  describe 'dependent nullify' do
    let(:project) { projects(:one) }

    it 'nullifies associated items when project is destroyed' do
      item = Item.create!(
        user: project.user,
        project: project,
        item_type: 'action',
        status: 'inbox',
        energy_level: 'high'
      )
      project.destroy
      expect(item.reload.project_id).to be_nil
    end

    it 'does not destroy items when project is destroyed' do
      Item.create!(
        user: project.user,
        project: project,
        item_type: 'action',
        status: 'inbox',
        energy_level: 'high'
      )
      expect { project.destroy }.not_to change { Item.count }
    end
  end
end
