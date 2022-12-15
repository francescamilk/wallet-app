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

  def income_per_month(manager = false)
    teach_data = data_per_month("teacher")
    ta_data    = data_per_month("ta")

    teach_income = teach_data.map { |mo, days| days * 300 }
    ta_income    = ta_data.map { |mo, days| days * 100 }

    i = 0
    months_income = {}
    teach_data.each do |month, co|
      months_income[month] = teach_income[i] + ta_income[i]
      i += 1
    end

    last_month = months_income.keys.last
    months_income[last_month] += 2400 if manager
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

  def data_per_month(role)
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
