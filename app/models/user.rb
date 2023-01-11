class User < ApplicationRecord
  has_many :events, dependent: :delete_all
  has_many :check_lists, dependent: :delete_all
  has_many :to_dos, dependent: :delete_all
  def jwt_payload
    {
      user_id: id,
      email: email
    }
  end
end
