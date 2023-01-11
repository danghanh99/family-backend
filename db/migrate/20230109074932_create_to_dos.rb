class CreateToDos < ActiveRecord::Migration[7.0]
  def change
    create_table :to_dos do |t|
      t.belongs_to :user, index: true
      t.belongs_to :check_list, index: true
      t.string :todo_text
      t.boolean :is_done

      t.timestamps
    end
  end
end
