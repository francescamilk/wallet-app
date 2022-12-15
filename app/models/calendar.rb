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
        "day" => row["Day"]
      }

      spec["teacher"] = row["TA(Lecturer)"] if is_teacher
      spec["ta"]      = row["TA"] if is_ta

      specs << spec
    end

    self.update(specs: specs)
  end

  def total_income
    teacher_count * 300 + ta_count * 100
  end

  def income_per_month
    teach_data = days_per_months("teacher")
    ta_data    = days_per_months("ta")

    teach_income = teach_data.map { |mo, days| days * 300 }
    ta_income    = ta_data.map { |mo, days| days * 100 }

    i = 0
    months_income = {}
    teach_data.each do |month, co|
      months_income[month] = teach_income[i] + ta_income[i]
      i += 1
    end

    months_income
  end

  private

  def teacher_count
    self.specs.select { |spec| spec.key?("teacher") }.count
  end

  def ta_count
    self.specs.select { |spec| spec.key?("ta") }.count
  end

  def split_months
    months = self.specs.map { |hash| hash["day"].match(/-(?<m>\d+)-/)[:m].to_i }.uniq
    months_data = {}

    months.count.times do |i|
      month = Date::MONTHNAMES[months[i]]
      months_data[month] = specs.group_by do |hash|
        hash["day"].include?("-#{months[i]}-") 
      end[true]
    end

    months_data
  end

  def days_per_months(role)
    teacher_days = {}
    split_months.each do |month, array|
      count = array.count do |hash|
        hash.key?(role)
      end
      
      teacher_days[month] = count
    end
    teacher_days
  end
end
