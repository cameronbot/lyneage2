class Person
  include Mongoid::Document
  field :birth_name, type: String
  field :gender, type: Integer
  field :dob, type: Date
  field :dod, type: Date
  # field :parents, type: Array
  # field :children, type: Array
  # field :spouses, type: Array
  belongs_to :tree
  has_and_belongs_to_many :spouses, class_name: 'Person', inverse_of: :spouses
  has_and_belongs_to_many :parents, class_name: 'Person', inverse_of: :children
  has_and_belongs_to_many :children, class_name: 'Person', inverse_of: :parents

  after_create do |p|
    p.tree.inc(:person_count, 1)
  end
  after_destroy do |p|
    p.tree.inc(:person_count, -1)
  end
end
