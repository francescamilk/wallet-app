class AddSpecToCalendars < ActiveRecord::Migration[7.0]
  def change
    add_column :calendars, :specs, :string, array: true, default: []
  end
end
