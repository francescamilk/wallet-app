class Calendar < ApplicationRecord
  require 'csv'
  belongs_to :user

  def import(file)
    specs = []

    CSV.foreach(file.path, headers: true) do |row|
      row = row.map do |dataset|
        "#{dataset[0]} => #{dataset[1]}"
      end
      specs << row
    end

    self.update(specs: specs)
  end
end
