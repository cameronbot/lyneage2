class Page
  include Mongoid::Document
  field :title, type: String
  field :views, type: Integer
end
