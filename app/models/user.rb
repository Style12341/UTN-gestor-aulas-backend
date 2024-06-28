class User < ApplicationRecord
  has_secure_password
  enum :role, { bedel: 0, admin: 1 }
  enum :turno, { todos: 0, mañana: 1, tarde: 2, noche: 3 }
  validates :nombre, presence: true, if: :bedel?
  validates :apellido, presence: true, if: :bedel?
  validates :turno, presence: true, if: :bedel?
  def self.bedels
    User.where(role: :bedel)
  end

  def self.new_bedel(params)
    bedel = User.new(params)
    bedel.role = :bedel
    bedel
  end
end
