class Address < ActiveRecord::Base
  has_many :listings, dependent: :destroy

  validates :house_number, presence: true
  validates :street_name, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true, if: Proc.new { |o| %w(CA US).include? o.country }
  validates :province, presence: true, if: Proc.new { |o| %w(CA US).include? o.country }
  validates :country, presence: true

  strip_attributes

  def to_s
    lines = []
    lines << [self.house_number, self.street_name].compact.join(', ')
    lines << self.line_2
    lines << self.city
    lines << [self.province, self.postal_code].compact.join(', ')
    c = Carmen::Country.coded(self.country)
    lines << c.name  if c
    lines.compact.join("\n")
  end
end
