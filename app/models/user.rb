class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :calendars, dependent: :destroy

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
