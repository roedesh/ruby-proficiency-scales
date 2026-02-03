class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :contexts, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :projects, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
