class Person
  include Mongoid::Document
  field :birth_name, type: String
  field :gender, type: Integer
  field :dob, type: Date
  field :dod, type: Date
  field :parents, type: Array
  field :children, type: Array
  field :spouses, type: Array
end
