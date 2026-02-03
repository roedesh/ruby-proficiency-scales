class Item < ApplicationRecord
  ITEM_TYPES = %w[action project reference someday_maybe].freeze
  STATUSSES = %w[inbox next_action waiting_for completed archived].freeze
  ENERGY_LEVELS = %w[high medium low].freeze

  belongs_to :user
  belongs_to :context, optional: true
  belongs_to :project, optional: true
  has_many :item_tags, dependent: :destroy
  has_many :tags, through: :item_tags

  validates :item_type, inclusion: { in: ITEM_TYPES }
  validates :status, inclusion: { in: STATUSSES }
  validates :energy_level, inclusion: { in: ENERGY_LEVELS }
end
