class ToDo < ApplicationRecord
  belongs_to :check_list
  belongs_to :user
end
