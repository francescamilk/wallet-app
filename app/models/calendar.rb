class Calendar < ApplicationRecord
  require 'csv'
  belongs_to :user

  def import(file)
    self.update(specs: { 'working': 'yes' })
  end
end
