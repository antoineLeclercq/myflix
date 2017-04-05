class User < ActiveRecord::Base
  has_many :reviews

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 }
  validates :full_name, presence: true
end
