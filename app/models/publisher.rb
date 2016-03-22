class Publisher < ActiveRecord::Base
  has_many :listings, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: {in: 2..250}

  strip_attributes

  default_scope { order(:name) }

  def self.icon; 'fa-briefcase' end

  def to_s; self.name end

  def resource_name; "Publisher#{self.new_record? ? '' : " '#{self.to_s}'"}" end
end
