class AddDefaultValueToCheckedOff < ActiveRecord::Migration[6.1]
  # That's the more generic way to change a column
  def up
    change_column :items, :checked_off, :boolean, default: false
  end

  def down
    change_column :items, :checked_off, :boolean, default: nil
  end
end
