class Usuario < ApplicationRecord
  has_secure_password
  validates :type, presence: true
end
