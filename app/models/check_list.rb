class CheckList < ApplicationRecord
  has_many :to_dos, dependent: :delete_all
  belongs_to :user
end
