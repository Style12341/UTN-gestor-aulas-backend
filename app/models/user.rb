class User < ApplicationRecord
  has_secure_password
  validates :type, presence: true
end
