class ToDoSerializer < ActiveModel::Serializer
  attributes :id, :todo_text, :is_done, :user_id, :created_at, :updated_at
end
