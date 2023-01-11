class EventSerializer < ActiveModel::Serializer
  attributes :id, :parent_id, :start_time, :end_time, :name, :description, :daily, :weekly, :monthly,
             :is_cancelled, :created_at, :updated_at, :user_id
end
