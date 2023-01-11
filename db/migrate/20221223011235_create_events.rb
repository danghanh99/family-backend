class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.string :description
      t.boolean :daily, default: false
      t.boolean :weekly, default: false
      t.boolean :monthly, default: false
      t.boolean :is_cancelled, default: false
      t.string :parent_id

      t.timestamps
    end
  end
end
