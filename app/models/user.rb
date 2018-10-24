class User < ApplicationRecord
  # enum usertype: [:standard, :pro, :custom]
  validates_presence_of :email
end
