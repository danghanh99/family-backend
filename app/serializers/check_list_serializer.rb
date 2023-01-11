class CheckListSerializer < ActiveModel::Serializer
  has_many :to_dos
  attributes :id, :name, :user_id, :created_at, :updated_at
  class ToDoSerializer < ActiveModel::Serializer
    attributes :id, :todo_text, :is_done, :user_id, :created_at, :updated_at
  end
end
