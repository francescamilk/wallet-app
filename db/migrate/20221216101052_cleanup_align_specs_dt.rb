class CleanupAlignSpecsDt < ActiveRecord::Migration[7.0]
  def change
    remove_column :calendars, :specs
    add_column :calendars, :specs, :json
  end
end
