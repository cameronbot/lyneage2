class Tree
  include Mongoid::Document

  belongs_to :user
  has_many :people
  
  field :name, type: String
  field :description, type: String
end
