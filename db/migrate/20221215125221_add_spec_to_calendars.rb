class AddSpecToCalendars < ActiveRecord::Migration[7.0]
  def change
    add_column :calendars, :specs, :json, default: {}
  end
end
