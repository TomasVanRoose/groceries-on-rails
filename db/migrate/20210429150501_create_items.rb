class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name
      t.boolean :checked_off
      t.integer :position

      t.timestamps
    end
  end
end
