class Listing < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  LIMIT_PER_PAGE = 6
  SPHINX_MAX_MATCHES = 10_000
  SPHINX_MIN_QUERY_LENGTH = 3

  belongs_to :publisher
  validates :publisher, presence: true

  belongs_to :address
  accepts_nested_attributes_for :address
  validates_associated :address
  validates_presence_of :address

  belongs_to :geolocation
  accepts_nested_attributes_for :geolocation
  validates_associated :geolocation
  validates_presence_of :geolocation

  has_many :photos, class_name: 'ListingPhoto', dependent: :destroy

  before_save :before_save
  after_destroy :after_destroy

  strip_attributes

  default_scope { order(:title) }
  scope :by_publisher, ->(publisher_id) { where(publisher_id: publisher_id).order(:title) }
  scope :by_city, ->(city) { joins(:address).where(addresses: {city: city}).order(:title) }

  def self.icon; 'fa-home' end

  def to_s; self.title end

  def resource_name; "Listing#{self.new_record? ? '' : " '#{self.to_s}'"}" end

  def slug_candidates
    [
        :title,
        [:title, ->{ self.address ? self.address.city : 'CITY' }, ->{ self.address ? self.address.province : 'PROVINCE' }],
        [:title, ->{ self.address ? self.address.house_number : 'NUM' }, ->{ self.address ? self.address.street_name : 'STREET' }, ->{ self.address ? self.address.city : 'CITY' }, ->{ self.address ? self.address.province : 'PROVINCE' }]
    ]
  end

  class << self
    def total_count(params)
      conditions, opts = sql_conditions(params)

      query = "
        SELECT COUNT(*) AS total_count
        FROM #{table_name} listing
            #{opts[:cluster_level_1] ? "JOIN #{Geolocation.table_name} geo ON listing.geolocation_id = geo.id" : ''}
            #{opts[:country] || opts[:province] || opts[:city] ? "JOIN #{Address.table_name} addr ON listing.address_id = addr.id" : ''}
      #{conditions.present? ? "WHERE #{conditions.join(' AND ')}" : ''}"

      sql = send(:sanitize_sql_array, [query, opts])

      connection.select_one(sql)['total_count'].to_i rescue 0
    end

    def list(params)
      conditions, opts = sql_conditions(params)
      opts.merge!(
          limit: LIMIT_PER_PAGE,
          offset: LIMIT_PER_PAGE * [params[:page].to_i, 0].max
      )

      query = "
        SELECT listing.*, COUNT(*) OVER() AS total_count
        FROM #{table_name} listing
            #{opts[:cluster_level_1] ? "JOIN #{Geolocation.table_name} geo ON listing.geolocation_id = geo.id" : ''}
            #{opts[:country] || opts[:province] || opts[:city] ? "JOIN #{Address.table_name} addr ON listing.address_id = addr.id" : ''}
        #{conditions.present? ? "WHERE #{conditions.join(' AND ')}" : ''}
        ORDER BY listing.published_at DESC
        LIMIT :limit OFFSET :offset"

      sql = send(:sanitize_sql_array, [query, opts])

      rows = connection.select_all(sql)
      total_count = rows.first['total_count'].to_i rescue 0

      [rows, total_count]
    end

    def list_nearby(params)
      lat = Geolocation.degrees_to_radians(params[:lat].to_f)
      lng = Geolocation.degrees_to_radians(params[:lng].to_f)

      opts = {
          geo: [lat, lng],
          select: '*, weight() as relevance',
          order: 'geodist ASC, published_at DESC, relevance DESC',
          sql: {include: [:address]},
          populate: true,
          per_page: (limit = params[:limit].to_i) > 0 ? limit : 20
      }
      rows = search(params[:q], opts)
      total_count = search_count(params[:q], opts)

      [rows, total_count]
    end

    private

    def sql_conditions(params)
      conditions = []
      opts = {}

      if params[:age].present?
        opts[:from_date] = Time.now - params[:age].to_i.day
        conditions << 'listing.published_at >= :from_date'
      end

      if params[:cluster].present?
        if params[:cluster][0] == '_'
          cluster_level = [params[:cluster].length - 1, Geolocation::CLUSTER_LEVELS.count].min

          1.upto(cluster_level) do |i|
            opts["cluster_level_#{i}".to_sym] = params[:cluster][i]
            conditions << "geo.cluster_level_#{i} = :cluster_level_#{i}"
          end
        else
          opts[:geolocation_id] = params[:cluster].to_i
          conditions << 'listing.geolocation_id = :geolocation_id'
        end
      end

      %w(country province postal_code city).each do |attr|
        sym = attr.to_sym
        if params[sym].present?
          opts[sym] = params[sym]
          opts[sym] = opts[sym].upcase if %w(country province).include?(attr)
          conditions << "addr.#{attr} = :#{attr}"
        end
      end

      if params[:q].present? && params[:q].length >= SPHINX_MIN_QUERY_LENGTH
        opts[:listing_ids] = search_for_ids(
            params[:q],
            max_matches: SPHINX_MAX_MATCHES,
            per_page: SPHINX_MAX_MATCHES
        )
        conditions << 'listing.id IN (:listing_ids)'
      end

      [conditions, opts]
    end
  end

  private

  def autosave_associated_records_for_address
    if self.address.new_record? || self.address.changed? && self.address.listings.count > 1
      self.address = Address.find_or_create_by!(
          self.address.attributes.select{ |k, _| !%w(id created_at updated_at).include? k }
      )
    else
      self.address.save!
    end
  end

  def autosave_associated_records_for_geolocation
    if self.geolocation.new_record? || self.geolocation.changed? && self.geolocation.listings.count > 1
      self.geolocation = Geolocation.find_or_create_by!(
          self.geolocation.attributes.select{ |k, _| %w(latitude longitude).include? k }
      )
    else
      self.geolocation.save!
    end
  end

  def before_save
    if self.title
      self.title &&= (self.title.strip)[0, 250].strip
      self.title.gsub!(/\//, ' / ')
      self.title.gsub!(/[\f\t ]/, ' ')
      self.title.gsub!(/\s+/, ' ')
    end

    if self.description
      self.description.gsub!(/[\f\t ]/, ' ')
      self.description.gsub!(/\s+/, ' ')
    end
  end

  def after_destroy
    if self.address.listings.count.zero?
      self.address.destroy
    end
    if self.geolocation.listings.count.zero?
      self.geolocation.destroy
    end
  end
end
