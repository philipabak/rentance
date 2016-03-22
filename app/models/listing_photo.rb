class ListingPhoto < ActiveRecord::Base
  belongs_to :listing

  has_attached_file :photo, styles: {thumb: '278x210#', small: '700x410#', medium: '1024x600#'}
  validates_attachment :photo, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }

  default_scope { order(:position) }
  scope :by_listing, ->(listing_id) { where(listing_id: listing_id).order(:position) }

  def self.icon; 'fa-picture-o' end

  def resource_name; 'Listing Photo' end

  def collection_id; self.listing_id end
end
