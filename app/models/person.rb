class Person
  include Mongoid::Document
  include Mongoid::Geospatial

  field :birth_name, type: String
  field :gender, type: Integer

  field :dob_y, type: Integer
  field :dob_m, type: Integer
  field :dob_d, type: Integer
  field :dod_y, type: Integer
  field :dod_m, type: Integer
  field :dod_d, type: Integer

  field :living, type: Boolean

  field :birth_loc, type: String
  geo_field :birth_coords
  field :death_loc, type: String
  geo_field :death_coords

  field :notes, type: String
  field :sources, type: String

  belongs_to :tree
  has_and_belongs_to_many :spouses, class_name: 'Person', inverse_of: :spouses
  has_and_belongs_to_many :parents, class_name: 'Person', inverse_of: :children
  has_and_belongs_to_many :children, class_name: 'Person', inverse_of: :parents

  def dob
	  @dob = partial_date(@dob_y, @dob_m, @dob_d)
	end

	def dob=(val)

	end

	def tag_list=(val)
	  @tag_list = val
	end
  after_create do |p|
    p.tree.inc(:person_count, 1)
  end
  after_destroy do |p|
    p.tree.inc(:person_count, -1)
  end

  private

  def partial_date (year, month, day)
  	# TODO
  end
end
