class Calendar < ApplicationRecord
  require 'csv'
  belongs_to :user

  def import(file)
    specs = []

    CSV.foreach(file.path, headers: true) do |row|
      row["TA(Lecturer)"] = row["TA(Lecturer)"].match(/\w+\s\w+/).to_s

      is_teacher = row["TA(Lecturer)"] == self.user.full_name
      is_ta      = row["TA"] == self.user.full_name
      next unless is_ta || is_teacher

      spec = {
        day: row["Day"].to_date
      }

      spec[:teacher] = row["TA(Lecturer)"] if is_teacher
      spec[:ta]      = row["TA"] if is_ta

      specs << spec 
    end

    self.update(specs: specs)
  end
end
