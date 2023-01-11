class CreateCheckLists < ActiveRecord::Migration[7.0]
  def change
    create_table :check_lists do |t|
      t.belongs_to :user, index: true
      t.string :name

      t.timestamps
    end
  end
end
