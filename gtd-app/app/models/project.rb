class Project < ApplicationRecord
  STATUSSES = %w[active on_hold completed].freeze

  belongs_to :user
  has_many :items, dependent: :nullify

  validates :status, inclusion: { in: STATUSSES }
end
