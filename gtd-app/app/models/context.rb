class Context < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :nullify

  validates :name, presence: true
end
